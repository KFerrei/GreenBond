//
//  CreateComment.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 5/7/2024.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI


struct CreateComment: View {
    @Binding var myProfile: User?
    var challenge: BondChallenges?
    var comment : Comment?
    var nbChallenges : Int
    var nbComments: Int
    
    @State private var postText: String = ""
    @State private var sliderValue: Float = 0
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @State var commentPicData : Data?
    @State var showImagePicker : Bool = false
    @State var photoItem: PhotosPickerItem?
    
    @FocusState private var showKeyboard: Bool
    
    @AppStorage("need_fetchingComment") var need_fetchingComment: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Button("Cancel", role: .destructive){
                    dismiss()
                }
                .font(.callout)
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .hAlign(.leading)
                if comment == nil{
                    
                    Button(action: createComment){
                        Text ("Save")
                            .font(.callout)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 6)
                            .background(.white, in: Capsule())
                    }.disableWithOpacity(postText.isEmpty)
                        .hAlign(.center)
                    
                    Button("Done"){
                        showKeyboard = false
                    }
                    .foregroundColor(.white)
                    .hAlign(.trailing)
                }
                
                
            }
            .hAlign(.center)
            .padding (.horizontal, 15)
            .padding(.vertical,10)
            .background{
                Rectangle()
                    .fill(Color("mainColor"))
                    .ignoresSafeArea()
            }
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    Text(challenge!.text)
                        .bold()
                        .padding(.top, 20)
                    if comment == nil{
                        GeometryReader { geometry in
                            
                            ZStack{
                                Rectangle()
                                    .frame(width: geometry.size.width + 5, height: 205)
                                    .foregroundColor(.white)
                                
                                if let commentPicData, let image = UIImage(data: commentPicData){
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }else{
                                    Image(systemName: "photo.badge.arrow.down")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color("mainColor"))
                                }
                            }
                            .frame(width: geometry.size.width, height: 200)
                            .clipShape(Rectangle())
                            .contentShape(Rectangle())
                            .cornerRadius(10)
                            .onTapGesture {
                                showImagePicker.toggle()
                            }
                        }.frame(height: 215)
                    } else {
                        if comment!.commentImageID != ""{
                            GeometryReader { geometry in
                                WebImage(url: comment!.commentURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: 200)
                                    .clipShape(Rectangle())
                                    .contentShape(Rectangle())
                                    .cornerRadius(10)
                            }.frame(height: 215)
                        }
                    }
                    
                    
                    if comment == nil{
                        
                        Text("Do you feel alone today?")
                            .font(.headline)
                            .padding()
                        
                        HStack {
                            Text("Yes")
                            Slider(value: $sliderValue, in: 0...1)
                            Text("No")
                        }
                        .padding()
                        
                        Text("\(nuancedResponse(for: sliderValue))")
                            .padding()
                        
                        Text("Description:")
                            .font(.callout)
                            .italic()
                            .hAlign(.leading)
                        
                        TextEditor(text: $postText)
                            .frame(minHeight: 100) // Set minimum height
                            .border(1, Color("mainColor").opacity(0.5))
                            .hAlign(.leading)
                            .vAlign(.top)
                    } else {
                        Text(comment!.text)
                            .hAlign(.leading)
                            .vAlign(.top)
                    }
                    
                }
                .padding(.horizontal, 20)
                .focused($showKeyboard)
            }
            
        }
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem){
            if let photoItem{
                Task{
                    if let rawImageData = try await photoItem.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5){
                        await MainActor.run(body: {
                            commentPicData = compressedImageData
                        })
                    }
                }
            }
        }
        .vAlign(.top)
        .alert(errorMessage, isPresented: $showError, actions: {})
        .overlay{
            LoadingView(show: $isLoading)
        }
    }
    
    func nuancedResponse(for value: Float) -> String {
        switch value {
        case 0..<0.2:
            return "Strongly Yes"
        case 0.2..<0.4:
            return "Yes"
        case 0.4..<0.6:
            return "Neutral"
        case 0.6..<0.8:
            return "No"
        case 0.8...1:
            return "Strongly No"
        default:
            return "Neutral"
        }
    }
    
    func createComment(){
        isLoading = true
        showKeyboard = false
        Task{
            do{
                let imageReferenceID = "\(myProfile!.userUID)\(challenge!.id!)"
                let storageRef = Storage.storage().reference().child("ChallengeImages").child(imageReferenceID)
                if let commentPicData{
                    let _ = try await storageRef.putDataAsync(commentPicData)
                    let dowloadURL = try await storageRef.downloadURL()
                    
                    let post = Comment(challengeID: challenge!.id!, userID: myProfile!.userUID, text: postText, commentURL: dowloadURL, commentImageID: imageReferenceID)
                    try await createDocumentAtFirebase(post)
                }else{
                    let post = Comment(challengeID: challenge!.id!, userID: myProfile!.userUID, text: postText)
                    try await createDocumentAtFirebase(post)
                }
            }catch{
                print(error)
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ post: Comment)async throws{
        let doc = Firestore.firestore().collection("Comments").document()
        let _ = try doc.setData(from: post, completion: {error in
            if error == nil{
                updateUser()
                var updatedPost = post
                updatedPost.id = doc.documentID
                need_fetchingComment = true
            }
        })
    }
    
    func updateUser(){
        do {
            myProfile?.userGreenCoins = myProfile!.userGreenCoins + challenge!.greenPoints
            myProfile?.userProgress[Int(Calendar.current.component(.month, from: Date()))-1] =  myProfile!.userProgress[Int(Calendar.current.component(.month, from: Date()))-1] + 100.0/Float(nbChallenges)
            
            let a = (myProfile!.userLonelinessProgress[Int(Calendar.current.component(.month, from: Date()))-1] * Float(nbComments) + sliderValue)
            myProfile?.userLonelinessProgress[Int(Calendar.current.component(.month, from: Date()))-1] = a/Float(nbComments+1)
            
            let doc = Firestore.firestore().collection("Users").document(myProfile!.userUID)
            
            try doc.setData(from: myProfile, completion : {error in
                if error == nil{
                    isLoading = false
                    dismiss()
                }
            })
        } catch {
            print("erreur")
            
        }
    }

    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

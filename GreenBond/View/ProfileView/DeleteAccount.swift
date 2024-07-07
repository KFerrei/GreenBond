//
//  DeleteAccount.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 6/7/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage


struct DeleteAccount: View {
    @Binding var myProfile: User?
    
    @Environment(\.dismiss) private var dismiss
    @State var showError: Bool =  false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    @State var emailID : String = ""
    @State var password: String = ""
    
    @AppStorage("log_status") var logStatus: Bool = true
    
    var body: some View {
        ZStack {
            WaveShape(points: WaveShapePoint.points_Down1)
                .fill(AppColors.greenColor)
                .frame(width: 100, height: 100)
                .scaleEffect(x: 1.3, y: 1.3)
                .offset(x: -150, y: 150)
                .zIndex(0)
            
            WaveShape(points: WaveShapePoint.points_Up1)
                .fill(AppColors.greenColor)
                .frame(width: 100, height: 100)
                .scaleEffect(x: 1, y: 1.2)
                .offset(x: -250, y: -400)
                .zIndex(0)
            
            VStack(spacing: 10){
                
                
                
                Text("We are sad")
                    .font(.system(size: 50).bold())
                    .hAlign(.leading)
                    .padding(.top,25)
                Text("to see you go...")
                    .font(.system(size: 50).bold())
                    .hAlign(.leading)

                VStack(spacing: 10){
                    TextField("email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                        .padding(.top,25)
                    
                    SecureField("password", text: $password)
                        .textContentType(.password)
                        .border(1, .gray.opacity(0.5))
                    
                    HStack{
                        Button(role: .destructive, action: {dismiss()}){
                            Text("cancel")
                                .foregroundColor(.black)
                                .hAlign(.center)
                                .border(2, .black)
                        }
                        
                        Button(action: deleteAccount){
                            Text("delete account")
                                .foregroundColor(.white)
                                .hAlign(.center)
                                .fillView(.black)
                        }
                        .disableWithOpacity(myProfile?.userEmail.lowercased() != emailID.lowercased())
                    }
                    .hAlign(.center)
                    
                }
            }
            .vAlign(.center)
            .padding(20)
            .padding(.bottom, 200)
            .zIndex(1)
        }
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
    }
    
    func deleteAccount(){
        isLoading = true
        Task{
            do{
                
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                
                let db = Firestore.firestore()
                let batch = db.batch()
                let userDocRef = db.collection("Users").document(userUID)
                
                // Step 1: First Deleting Profile Image From Storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                
                let commentsQuery = db.collection("Comments").whereField("userID", isEqualTo: userUID)
                let commentDocs = try await commentsQuery.getDocuments()
                for document in commentDocs.documents {
                    if let imageID = document.get("commentImageID") as? String, imageID != ""{
                        print("deleting image")
                        let reference = Storage.storage().reference().child("ChallengeImages").child(imageID)
                        try await reference.delete()
                    }
                    batch.deleteDocument(document.reference)
                }
                
                batch.deleteDocument(userDocRef)

                //Step 2: Deletino Firestore User Document
                try await batch.commit()
                try await Auth.auth().currentUser?.delete()
                logStatus = false
                
                dismiss()
                
            }catch{
                await setError(error)
            }
            
        }
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}



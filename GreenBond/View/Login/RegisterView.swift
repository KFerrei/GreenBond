//  RegisterView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 20/6/2024.
//  Modified by FERREIRA Kévin on 23/6/2024.

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct RegisterView: View {
    
    @State var emailID : String = ""
    @State var password: String = ""
    @State var userGender: String = ""
    @State var userGivenName: String = ""
    @State var userFamilyName: String = ""
    @State var userName: String = ""
    @State var userBirthDate: Date = Date()
    @State var userCity: String = ""
    
    @State var userProfilePicData : Data?
    @State var showImagePicker : Bool = false
    @State var photoItem: PhotosPickerItem?
    
    @State var isLoading: Bool = false
    
    @State var showError: Bool =  false
    @State var errorMessage: String = ""
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("last_fetchingUser") var last_fetchingUser: String = ""
    @AppStorage("need_fetchUser") var need_fetchUser: Bool = false
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {

            VStack{
                WaveShape(points: WaveShapePoint.points_Up2)
                    .fill(AppColors.greenColor)
                    .frame(maxWidth: .infinity, maxHeight: 300)

                Spacer()
                
                WaveShape(points: WaveShapePoint.points_Down2)
                    .fill(AppColors.greenColor)
                    .frame(maxWidth: .infinity, maxHeight: 300)

            }
            .zIndex(0)
            .vAlign(.center)
            .ignoresSafeArea()
        
            
            VStack(spacing: 10){
                VStack(spacing: 10){
                    ZStack{
                        Circle()
                            .frame(width: 105, height: 105)
                            .foregroundColor(.white)
                        ZStack{
                            if let userProfilePicData, let image = UIImage(data: userProfilePicData){
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }else{
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundColor(Color(hex: "105b37"))
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            showImagePicker.toggle()
                        }
                    }
                    
                    HStack{
                        Picker("gender", selection: $userGender){
                            ForEach(AppConstants.Lists.genders, id: \.self) {
                                Text($0)
                            }
                        }
                        .tint(.black)
                        TextField("user name", text: $userName)
                            .textContentType(.givenName)
                            .border(1, .gray.opacity(0.5))
                    }
                    HStack{
                        TextField("given name", text: $userGivenName)
                            .textContentType(.givenName)
                            .border(1, .gray.opacity(0.5))
                        
                        
                        TextField("family name", text: $userFamilyName)
                            .textContentType(.familyName)
                            .border(1, .gray.opacity(0.5))
                    }
                    
                    TextField("email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                    
                    SecureField("password", text: $password)
                        .textContentType(.password)
                        .border(1, .gray.opacity(0.5))
                    
                    DatePicker("birth date", selection: $userBirthDate, displayedComponents: [.date])
                        .foregroundColor(.gray.opacity(0.5))
                        .border(1, .gray.opacity(0.5))
                    
                    Picker("city", selection: $userCity){
                        ForEach(AppConstants.Lists.cities, id: \.self) {
                            Text($0)
                        }
                    }
                    .hAlign(.leading)
                    .tint(.black)
                    .textContentType(.addressCityAndState)
                    .border(1, .gray.opacity(0.5))
                
                    
                    Button(action: registerUser){
                        Text("sign up")
                            .foregroundColor(.white)
                            .hAlign(.center)
                            .fillView(.black)
                    }
                    .disableWithOpacity(isFormValid())
                    .padding(.top, 10)
                    
                }
                
                HStack{
                    Text("already have an account?")
                        .foregroundColor(.white)
                    
                    Button("login now"){
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                }
                .hAlign(.center)
                .vAlign(.bottom)
                
            }
            .vAlign(.top)
            .padding(20)
            .zIndex(1)
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            .photosPicker(isPresented:$showImagePicker, selection: $photoItem)
            .onChange(of: photoItem){
                if let photoItem{
                    Task{
                        do{
                            guard let imageData = try await photoItem.loadTransferable(type: Data.self) else{return}
                            await MainActor.run(body: {
                                userProfilePicData = imageData
                            })
                        }catch{}
                    }
                }
            }
            
            
        }
        .onAppear {
            userGender = AppConstants.Lists.genders[0]
            userCity = AppConstants.Lists.cities[0]
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
        
    }
    
    func isFormValid() -> Bool {
        let ageComponents = Calendar.current.dateComponents([.year], from: userBirthDate, to: Date())
        let age = ageComponents.year ?? 0
        return emailID.isEmpty ||
               password.isEmpty ||
               userGender.isEmpty ||
               userGivenName.isEmpty ||
               userFamilyName.isEmpty ||
               age <= 12 ||
               userCity.isEmpty ||
               userProfilePicData == nil
    }
    
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                guard let imageData = userProfilePicData else{return}
                
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                let dowloadURL = try await storageRef.downloadURL()
                
                let user = User(userGender: userGender, userGivenName: userGivenName, userFamilyName: userFamilyName, userName: userName, userProfileURL: dowloadURL, userCity: userCity, userBirthDate: userBirthDate, userEmail: emailID, userUID: userUID)
                
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion:{
                    error in
                    if error == nil{
                        logStatus = true
                        cacheUser(user)
                        last_fetchingUser = Functions.dateToString(date: Date())
                        need_fetchUser = false
                    }
                })
                
            }catch{
                await setError(error)
            }
        }
    }
    
    func cacheUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "cachedUser")
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

#Preview {
    RegisterView()
}

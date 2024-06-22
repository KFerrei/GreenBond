//  LoginView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 20/6/2024.
//  Modified by FERREIRA Kévin on 21/6/2024.

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    
    @State var emailID : String = ""
    @State var password: String = ""
    
    @State var createAccount: Bool = false
    @State var showError: Bool =  false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_given_name") var userGivenNameStored: String = ""
    @AppStorage("user_family_name") var userFamilyNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("user_profile_url") var profileURL: URL?

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(AppColors.greenColor))
                .frame(width: 300, height: 300)
                .offset(x: 150, y: -400)
                .zIndex(0)
            
            Circle()
                .fill(Color(AppColors.greenColor))
                .frame(width: 400, height: 400)
                .offset(x: -20, y: 300)
                .zIndex(0)
            
            VStack(spacing: 10){
                Text("green bond")
                    .font(.system(size: 50).bold())
                    .hAlign(.center)
                
                VStack(spacing: 10){
                    TextField("email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                        .padding(.top,25)
                    
                    SecureField("password", text: $password)
                        .textContentType(.password)
                        .border(1, .gray.opacity(0.5))
                    
                    Button(action: loginUser){
                        Text("sign in")
                            .foregroundColor(.white)
                            .hAlign(.center)
                            .fillView(.black)
                    }.padding(.top, 10)
                    
                    Button("reset password?", action: resetPassword)
                        .font(.callout)
                        .fontWeight(.medium)
                        .tint(.black)
                        .hAlign(.trailing)
                    
                }
                
                HStack{
                    Text("don't have an account yet?")
                    
                    Button("register now"){
                        createAccount.toggle()
                        
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    
                }
                .hAlign(.center)
                .vAlign(.bottom)
                
            }
            .vAlign(.center)
            .padding(20)
            .padding(.top, 100)
            .zIndex(1)
            
        }          
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
                .transition(.move(edge: .leading))
        }
        .alert(errorMessage, isPresented: $showError, actions: {})

    }
    
    func loginUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                try await fetchUser()
            }catch{
                await setError(error)
            }
        }
    }
    
    func fetchUser()async throws{
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        await MainActor.run(body: {
            logStatus = true
            userGivenNameStored = user.userName
            userFamilyNameStored = user.userFamilyName
            userUID = userID
            profileURL = user.userProfileURL

        })
    }
    
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
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

#Preview {
    LoginView()
}

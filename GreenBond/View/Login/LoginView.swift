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
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("is_Premium") var isPremium: Bool = false
    @AppStorage("is_Admin") var isAdmin: Bool = false

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
                Text("green bond")
                    .font(.system(size: 50).bold())
                    .hAlign(.center)
                    .padding(.top,25)
                
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
                    Text("don't have an account yet?").foregroundColor(.white)
                    
                    Button("register now"){
                        createAccount.toggle()
                        
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    
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
            userNameStored = user.userName
            userUID = userID
            profileURL = user.userProfileURL
            isPremium = (Date() < user.userDatePremium)
            isAdmin = user.isAdmin

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

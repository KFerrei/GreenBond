//  LoginView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 20/6/2024.
//  Modified by FERREIRA Kévin on 7/7/2024.

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
    @AppStorage("last_fetchingUser") var last_fetchingUser: String = ""
    @AppStorage("need_fetchUser") var need_fetchUser: Bool = false

    var body: some View {
        ZStack {
            VStack{
                WaveShape(points: WaveShapePoint.points_Up1)
                    .fill(Color("mainColor"))
                    .frame(maxWidth: .infinity, maxHeight: 250)

                Spacer()
                
                WaveShape(points: WaveShapePoint.points_Down1)
                    .fill(Color("mainColor"))
                    .frame(maxWidth: .infinity, maxHeight: 300)

            }
            .ignoresSafeArea()
            
            
            VStack(spacing: 10){
                
                Text("green bond")
                    .font(.system(size: 50).bold())
                    .hAlign(.center)
                    .padding(.top,20)
                
                VStack(spacing: 10){
                    TextField("email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                        .padding(.top,20)
                    
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
                        .fontWeight(.medium)
                        .tint(.black)
                        .hAlign(.trailing)

                }
                
                HStack{
                    Text("don't have an account?").foregroundColor(.white)
                    
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
            if isLoading{
                ZStack{
                    Rectangle()
                        .fill(.white)
                    LoadingView(show: $isLoading)
                }
                .ignoresSafeArea()
            }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                logStatus = true
            }
            cacheUser(user)
            last_fetchingUser = Functions.dateToString(date: Date(), form: "dd/MM/yy")
            need_fetchUser = false
        })
    }
    
    func cacheUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "cachedUser")
        }
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

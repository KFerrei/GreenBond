//  ProfileView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State var showError: Bool =  false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                if let myProfile{
                    ProfileContent()
                    //ProfileContent(user: myProfile)
                        .refreshable {
                            self.myProfile = nil
                            await fetchUserData()
                        }
                } else{
                    ProgressView()
                }
            }
            .navigationTitle("my profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu {
                        Button("log out", action: logOutUser)
                        
                        Button("deleta account", role: .destructive, action: deleteAccount)
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }            
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .alert(errorMessage, isPresented: $showError, actions: {})
        .task({
            if myProfile != nil{return}
            await fetchUserData()
        })
    }
    
    func fetchUserData()async{
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else{return}
        await MainActor.run(body: {
            myProfile = user
        })
        
    }
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    func deleteAccount(){
        isLoading = true
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                // Step 1: First Deleting Profile Image From Storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                //Step 2: Deletino Firestore User Document
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                try await Auth.auth().currentUser?.delete()
                logStatus = false
                
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
    ProfileView()
}

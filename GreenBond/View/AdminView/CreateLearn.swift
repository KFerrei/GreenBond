//  CreateLearn.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 2/7/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CreateLearn: View {
    
    var onPost: (LearnPost)->()
    
    @State private var postText: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack{
            HStack{
                Button("Cancel", role: .destructive){
                    dismiss()
                }
                .font(.callout)
                .foregroundColor(.white)
                
                Spacer()
                
                Button(action: createPost){
                    Text ("Post")
                        .font(.callout)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(.white, in: Capsule())
                }.disableWithOpacity(postText == "")
                
                Spacer()
                
                Button("Done"){
                    showKeyboard = false
                }
                .foregroundColor(.white)
                
            }
            .hAlign(.center)
            .padding (.horizontal, 15)
            .padding(.vertical,10)
            .background{
                Rectangle()
                    .fill(AppColors.greenColor)
                    .ignoresSafeArea()
            }
            VStack(spacing: 15){
                TextField("Content", text: $postText, axis: .vertical)
            }.padding(15)
                .focused($showKeyboard)
            
        }
        .vAlign(.top)
        .alert(errorMessage, isPresented: $showError, actions: {})
        .overlay{
            LoadingView(show: $isLoading)
        }
    }
    
    func createPost(){
        isLoading = true
        showKeyboard = false
        Task{
            do{
                let post = LearnPost(text: postText)
                try await createDocumentAtFirebase(post)
                
            }catch{
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ post: LearnPost)async throws{
        let doc = Firestore.firestore().collection("LearnPosts").document()
        let _ = try doc.setData(from: post, completion: {error in
            if error == nil{
                isLoading = false
                var updatedPost = post
                updatedPost.id = doc.documentID
                onPost(updatedPost)
                dismiss()
            }
        })
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

#Preview{
    CreateLearn{_ in
    }
}




//
//  LearnPostCardView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 2/7/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct LearnPostCardView: View {
    var post: LearnPost
    
    var onUpdate: (LearnPost)->()
    var onDelete: ()->()
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("is_Admin") var isAdmin: Bool = false
    @State private var docListener: ListenerRegistration?
    
    var body: some View {
        let random_color: Int = Int.random(in: 0..<2)
        
        VStack(alignment: .leading, spacing: 6){
            Text(post.text)
                .foregroundColor(AppColors.greenColor)
                
            HStack{
                if isAdmin{
                    Button(role:.destructive, action: deletePost, label: {Image(systemName: "trash")
                            .foregroundColor(AppColors.greenColor)
                    })
                }
                Spacer()
                PostInteraction()
            }
            .hAlign(.trailing)
        }
        .hAlign(.center)
        .border(3, AppColors.greenColor)
        .padding(.horizontal, 15)
        .onAppear{
            if docListener == nil{
                guard let postID = post.id else {return}
                docListener = Firestore.firestore().collection("LearnPosts").document(postID).addSnapshotListener({ snapshot, error in
                    if let snapshot{
                        if snapshot.exists{
                            if let updatedPost = try? snapshot.data(as: LearnPost.self){
                                onUpdate(updatedPost)
                            }
                        } else {
                            onDelete()
                        }
                    }
                })
            }
        }
        .onDisappear{
            if let docListener{
                docListener.remove()
                self.docListener = nil 
            }
        }
    }
    
    @ViewBuilder
    func PostInteraction()->some View{
        
        HStack{
            Text("\(post.likedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Button(action: likePost){
                Image(systemName: post.likedIDs.contains(userUID) ? "heart.fill": "heart")
            }
        
        }
        .foregroundColor(AppColors.greenColor)
    }
    
    func likePost(){
        Task{
            guard let postID = post.id else{return}
            if post.likedIDs.contains(userUID){
                try await Firestore.firestore().collection("LearnPosts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
            } else{
                try await Firestore.firestore().collection("LearnPosts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
    
    func deletePost(){
        Task{
            do{
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("LearnPosts").document(postID).delete()
            } catch{
                
            }
        }
    }
}

//#Preview {
//    LearnPostCardView()
//}

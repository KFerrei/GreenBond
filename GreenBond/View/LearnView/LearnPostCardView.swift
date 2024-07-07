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
    @Binding var myProfile: User?
    
    var onUpdate: (LearnPost)->()
    var onDelete: ()->()

    @State private var docListener: ListenerRegistration?
    
    var body: some View {
        
        VStack(alignment: .center){
            VStack{
                Text(post.text)
                    .multilineTextAlignment(.center)
            }
            .hAlign(.center)
            .borderFillView(3, Color("mainColor"), .white)
                
            HStack{
                if (myProfile!.isAdmin){
                    Button(role:.destructive, action: deletePost, label: {Image(systemName: "trash")
                            .foregroundColor(Color("mainColor"))
                    })
                }
                Spacer()
                PostInteraction()
            }
        }
        .hAlign(.center)
        .padding(.horizontal, 20)
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
                Image(systemName: post.likedIDs.contains(myProfile!.userUID) ? "heart.fill": "heart")
            }
        
        }
        .foregroundColor(Color("mainColor"))
    }
    
    func likePost(){
        Task{
            guard let postID = post.id else{return}
            if post.likedIDs.contains(myProfile!.userUID){
                try await Firestore.firestore().collection("LearnPosts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([myProfile!.userUID])
                ])
            } else{
                try await Firestore.firestore().collection("LearnPosts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([myProfile!.userUID])
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

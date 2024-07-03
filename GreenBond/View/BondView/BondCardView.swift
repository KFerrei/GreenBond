//
//  BondCardView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 3/7/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct BondCardView: View {
    var post: BondChallenges
    
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
            }
            .hAlign(.trailing)
        }
        .hAlign(.center)
        .border(3, AppColors.greenColor)
        .padding(.horizontal, 15)
    }
    
    func deletePost(){
        Task{
            do{
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("BondChallenges").document(postID).delete()
            } catch{
                
            }
        }
    }
}


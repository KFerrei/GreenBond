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
    var comment: Comment?
    
    @Binding var openComment: Bool
    @Binding var commentToShow: Comment?
    @Binding var challengeToShow: BondChallenges?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6){
            Button(action: {
                commentToShow = comment
                challengeToShow = post
                openComment.toggle()
            }){
                HStack{
                    
                    Text(post.text)
                    VStack{
                        Image(systemName: comment != nil ? "checkmark": "minus")
                        Text(comment?.date != nil ? "\(Functions.dateToString(date: comment?.date ?? Date(), form: "dd/MM/yy"))": "--/--/--")
                        Text("\(post.greenPoints) gp")
                    }
                    .frame(width: 75)
                }
            }
        }
        .foregroundColor(comment?.date == nil ? .black: .white)
        .hAlign(.center)
        .borderFillView(3, Color("mainColor"), comment?.date == nil ? .white: Color("mainColor"))
        .padding(.horizontal, 20)

    }
}


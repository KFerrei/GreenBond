//
//  LearnView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 2/7/2024.
//

import SwiftUI

struct LearnView: View {
    @Binding var myProfile: User?
    
    @State private var recentsPosts: [LearnPost] = []
    @State private var createNewPost: Bool = false
        
    var body: some View {
        
        VStack{
            Text("LEARN")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .foregroundColor(AppColors.greenColor)
                .hAlign(.leading)
                .padding(.horizontal, 20)
            
            ReusableLearnPostView(learnPosts: $recentsPosts, myProfile: $myProfile)
                .hAlign(.center)
                .vAlign(.center)
            
        }
        .overlay(alignment: .bottomTrailing){
            if let myProfile = myProfile, myProfile.isAdmin{
                Button{
                    createNewPost.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(13)
                        .background(AppColors.greenColor, in: Circle())
                }
                .padding(20)
                .padding(.bottom, 25)
            }
        }
        .fullScreenCover(isPresented: $createNewPost){
            CreateLearn{ post in
                recentsPosts.insert(post, at:0)
                
            }
        }
    }
}


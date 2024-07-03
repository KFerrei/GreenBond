//
//  BondView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 3/7/2024.
//

import SwiftUI

struct BondView: View {
    @State private var recentsPosts: [BondChallenges] = []
    @State private var createNewPost: Bool = false
    
    @AppStorage("is_Admin") var isAdmin: Bool = false
    
    var body: some View {
        
        VStack{
            Text("BOND")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .foregroundColor(AppColors.greenColor)
                .hAlign(.leading)
                .padding(.horizontal, 20)
            HStack{
                
                Text(AppConstants.Lists.months[Int(Calendar.current.component(.month, from: Date()))-1])
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundColor(AppColors.greenColor)
                    .hAlign(.leading)
                    .padding(.horizontal, 20)
            }
            
            Capsule()
                .fill(AppColors.greenColor)
                .frame(width: 30, height: 10) //CGFloat(dataPoints[abs(index%12)]))
            
            ReusableBondView(learnPosts: $recentsPosts)
                .hAlign(.center)
                .vAlign(.center)
            
        }
        .overlay(alignment: .bottomTrailing){
            if isAdmin{
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
            CreateBond{ post in
                recentsPosts.insert(post, at:0)
                
            }
        }
    }
}

#Preview {
    BondView()
}


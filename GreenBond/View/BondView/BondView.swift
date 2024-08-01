//
//  BondView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 3/7/2024.
//

import SwiftUI

struct BondView: View {
    @Binding var myProfile: User?
    
    @State private var recentsPosts: [BondChallenges] = []
    @State private var recentComments: [Comment] = []
    @State private var createNewPost: Bool = false
    
    @State var openComment: Bool = false
    @State var commentToShow: Comment? = nil
    @State var challengeToShow: BondChallenges? = nil
    @State var nbChallenges: Int = 0
    @State var nbComments: Int = 0
    
    var body: some View {
        
        VStack{
            Text("BOND")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .foregroundColor(Color("mainColor"))
                .hAlign(.leading)
                .padding(.horizontal, 20)
            let progress = myProfile?.userProgress[Int(Calendar.current.component(.month, from: Date()))-1]
            HStack{
                Text(AppConstants.Lists.months[Int(Calendar.current.component(.month, from: Date()))-1])
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundColor(Color("mainColor"))
                    .hAlign(.leading)
                
                Text("\(Int(ceil(progress!)))%")
                    .font(.callout)
                    .italic()
                    .hAlign(.trailing)
            }
            .padding(.horizontal, 20)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
                    Capsule()
                        .fill(Color("mainColor").opacity(0.5))
                        .frame(height: 30)
                    Capsule()
                        .fill(Color("mainColor"))
                        .frame(width: geometry.size.width * CGFloat(progress!/100), height: 30)
                }
            }
            .frame(height: 30)
            .padding(.horizontal, 20)
            .padding(.top, -10)
            
            ReusableBondView(bondChallenges: $recentsPosts, commentChallenges: $recentComments, myProfile: $myProfile, openComment: $openComment, commentToShow: $commentToShow, challengeToShow: $challengeToShow, nbChallenges: $nbChallenges, nbComments: $nbComments)
                .hAlign(.center)
                .vAlign(.center)
            
        }
        .overlay(alignment: .bottomTrailing){
            if myProfile!.isAdmin{
                Button{
                    createNewPost.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(13)
                        .background(Color("mainColor"), in: Circle())
                }
                .padding(20)
                .padding(.bottom, 25)
            }
        }
        .onChange(of: openComment) {
            if !openComment {
                challengeToShow = nil
                commentToShow = nil
            }
        }
        .fullScreenCover(isPresented: $openComment) {
            if let challenge = challengeToShow {
                CreateComment(myProfile: $myProfile, challenge: challenge, comment: commentToShow, nbChallenges: nbChallenges, nbComments: nbComments)
            }
        }
        .fullScreenCover(isPresented: $createNewPost){
            CreateBond{ post in
                recentsPosts.insert(post, at:0)
                
            }
        }
    }
}


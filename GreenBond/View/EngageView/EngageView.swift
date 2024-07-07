//
//  EngageView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 6/7/2024.
//

import SwiftUI

struct EngageView: View {
    
    @Binding var myProfile: User?
    
    @State private var createNewWorkshop: Bool = false
    
    var body: some View {
        VStack{
                Text("ENGAGE")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundColor(AppColors.greenColor)
                    .hAlign(.leading)
                    .padding(.horizontal, 20)
                
                Text("\(myProfile!.userGreenCoins) green points")
                    .font(.title)
                    .italic()
                    .foregroundColor(.black)
                    .hAlign(.leading)
                    .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(AppConstants.Lists.themes, id: \.self){ theme in
                        Button(action: {}){
                            Text(theme)
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                                .padding(10)
                                .background(AppColors.greenColor)
                                .cornerRadius(10)
                        }
                    }
                }.padding(.horizontal, 20)
            }
            
            ReusableEngageView()
                .hAlign(.center)
                .vAlign(.center)
            
        }
        .overlay(alignment: .bottomTrailing){
            if myProfile!.isAdmin{
                Button{
                    createNewWorkshop.toggle()
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
        .fullScreenCover(isPresented: $createNewWorkshop){
            CreateWorkshop()
        }
    }
}



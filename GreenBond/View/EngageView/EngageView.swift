//
//  EngageView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 6/7/2024.
//

import SwiftUI

struct EngageView: View {
    
    @Binding var myProfile: User?
    
    @State private var workshops: [Workshop] = []
    
    @State private var createNewWorkshop: Bool = false
    @State private var selectedTheme: String = "All Workshops"
    
    @State var openWorkshop: Bool = false
    @State var workshopToShow: Workshop? = nil
    
    var body: some View {
        VStack{
                Text("ENGAGE")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundColor(Color("mainColor"))
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
                        Button(action: {selectedTheme = theme}){
                            Text(theme)
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color("mainColor"))
                                .cornerRadius(10)
                        }
                    }
                }.padding(.horizontal, 20)
            }
            
            ReusableEngageView(workshops: $workshops, myProfile: $myProfile, selectedTheme: $selectedTheme, openWorkshop: $openWorkshop, workshopToShow: $workshopToShow)
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
                        .background(Color("mainColor"), in: Circle())
                }
                .padding(20)
                .padding(.bottom, 25)
            }
        }
        .onChange(of: openWorkshop) {
            if !openWorkshop {
                workshopToShow = nil
            }
        }
        .fullScreenCover(isPresented: $openWorkshop) {
            if let workshop = workshopToShow {
                WorkshopView(myProfile: $myProfile, workshop: workshop)
            }
        }
        .fullScreenCover(isPresented: $createNewWorkshop){
            CreateWorkshop()
        }
    }
}



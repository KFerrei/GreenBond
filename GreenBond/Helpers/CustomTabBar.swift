//
//  CustomTabBar.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 23/6/2024.
//

import SwiftUI

enum Tabs: Int{
    case learn = 0
    case bond = 1
    case engage = 2
    case profile = 3
}
struct CustomTabBar: View {
    @Binding var selectedTab: Tabs
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color("mainColor"))
                .frame(height: 100)
            
            HStack{
                Button{
                    selectedTab = .learn
                } label:{
                    if selectedTab == .learn{
                        VStack{
                            Image(systemName: "book.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("learn")
                        }
                    } else {
                        VStack{
                            Image(systemName: "book.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("learn")
                        }
                    }
                }.tint(.white)
                    .padding(25)
                
                Button{
                    selectedTab = .bond
                } label:{
                    if selectedTab == .bond{
                        VStack{
                            Image(systemName: "trophy.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("bond")
                        }
                    } else {
                        VStack{
                            Image(systemName: "trophy.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("bond")
                        }
                    }
                }.tint(.white)
                    .padding(25)
                
                Button{
                    selectedTab = .engage
                } label:{
                    if selectedTab == .engage{
                        VStack{
                            Image(systemName: "hammer.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("engage")
                        }
                    } else {
                        VStack{
                            Image(systemName: "hammer.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("engage")
                        }
                    }
                }.tint(.white)
                    .padding(20)
                
                Button{
                    selectedTab = .profile
                } label:{
                    if selectedTab == .profile{
                        VStack{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("profile")
                        }
                    } else {
                        VStack{
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                            Text("profile")
                        }
                    }
            
                }
                .tint(.white)
                .padding(15)
            }
            .padding(.bottom, 20)
        }
    }
}


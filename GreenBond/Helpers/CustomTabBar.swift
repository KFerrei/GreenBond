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
                .fill(AppColors.greenColor)
                .frame(height: 80)
            
            HStack{
                Button{
                    selectedTab = .learn
                } label:{
                    if selectedTab == .learn{
                        Text("LEARN")
                    } else {
                        Text("learn")
                    }
                }.tint(.white)
                    .padding(25)
                
                Button{
                    selectedTab = .bond
                } label:{
                    if selectedTab == .bond{
                        Text("BOND")
                    } else {
                        Text("bond")
                    }
                }.tint(.white)
                    .padding(25)
                
                Button{
                    selectedTab = .engage
                } label:{
                    if selectedTab == .engage{
                        Text("ENGAGE")
                    } else {
                        Text("engage")
                    }
                }.tint(.white)
                    .padding(20)
                
                Button{
                    selectedTab = .profile
                } label:{
                    if selectedTab == .profile{
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
            
                }
                .tint(.white)
                .padding(15)
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.learn))
}

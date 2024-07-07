//  MainView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.

import SwiftUI

struct MainView: View {
    @State private var myProfile: User?
    @State private var selectedTab = Tabs.profile
    
    var body: some View {
        ZStack{
            Group{
                switch selectedTab {
                case .learn:
                    LearnView(myProfile: $myProfile)
                        .padding(.bottom, 55)
                case .bond:
                    BondView(myProfile: $myProfile)
                        .padding(.bottom, 55)
                case .engage:
                    EngageView(myProfile: $myProfile)
                        .padding(.bottom, 55)
                case .profile:
                    ProfileView(myProfile: $myProfile)
                        .padding(.bottom, 55)
                        
                }
            }
            
            VStack {
                CustomTabBar(selectedTab: $selectedTab)
            }
            .padding(.bottom, -25)
            .vAlign(.bottom)
            .ignoresSafeArea(edges: .bottom)
        
        }
    }
}


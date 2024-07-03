//  MainView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.

import SwiftUI

struct MainView: View {
    @State private var selectedTab = Tabs.profile

    var body: some View {
        ZStack{
            switch selectedTab {
            case .learn:
                LearnView()
                    .padding(.bottom, 55)
            case .bond:
                BondView()
                    .padding(.bottom, 55)
            case .engage:
                Text("engage")
            case .profile:
                ProfileView()
                    .padding(.bottom, 55)
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

#Preview {
    MainView()
}

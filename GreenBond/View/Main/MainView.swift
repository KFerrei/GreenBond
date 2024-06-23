//  MainView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.

import SwiftUI

struct MainView: View {
    @State private var selectedTab = Tabs.learn

    var body: some View {
        ZStack{
            switch selectedTab {
            case .learn:
                Text("learn")
            case .bond:
                Text("bond")
            case .engage:
                Text("engage")
            case .profile:
                ProfileView()
            }
            
            VStack {
                CustomTabBar(selectedTab: $selectedTab)
            }
            .padding(.bottom, -5)
            .vAlign(.bottom)
            .ignoresSafeArea(edges: .bottom)
        
        }
    }
}

#Preview {
    MainView()
}

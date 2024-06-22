//  MainView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.

import SwiftUI

struct MainView: View {
    @State private var selection = 1

    var body: some View {
        TabView(selection:$selection){
            Text("learn")
                .tabItem{
                    Text("learn")
                }.tag(1)
            
            Text("bond")
                .tabItem{
                    Text("bond")
                }.tag(2)
            
            Text("engage")
                .tabItem{
                    Text("engage")
                }.tag(3)
            
            ProfileView()
                .tabItem{
                    Text("profil")
                }.tag(4)
        }
        .accentColor(AppColors.greenColor)
    }
}

#Preview {
    MainView()
}

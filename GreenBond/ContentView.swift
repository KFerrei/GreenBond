//  ContentView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 20/6/2024.
//  Modified by FERREIRA Kévin on 07/7/2024.

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    @State private var showSplash: Bool = true
    
    var body: some View {
        ZStack{
            if logStatus{
                MainView()
            }else{
                LoginView()
            }
            
            
            if showSplash{
                ZStack{
                    Rectangle()
                        .fill(Color("mainColor"))

                    
                    AnimatedBlob(w: 450, h: 450, color: .white)
                        .frame(width: 450, height: 450)
                        .padding(.bottom, 150)
                    
                    Text("green bond")
                        .font(.system(size: 50).bold())
                        .hAlign(.center)
                        .foregroundColor(.black)
                        .padding(.bottom, 150)
                    
                }
                .ignoresSafeArea()
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()+5){
                withAnimation(.spring()){
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

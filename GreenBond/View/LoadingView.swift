//  LoadingView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 21/6/2024.
//  Modified by FERREIRA Kévin on 21/6/2024.

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    @State private var larger = true
    
    let animation = Animation
        .linear(duration: 1)
        .repeatForever(autoreverses: false)
        .delay(0.5)
    
    var body: some View {
        if show{
            ZStack{
                Circle()
                    .fill(AppColors.greenColor)
                    .frame(width: 50, height: 50)
                    .scaleEffect(larger ? 1.5 : 1)
                    .animation(.easeInOut(duration: 2).repeatForever(), value: larger)
                Circle()
                    .fill(AppColors.greenColor.opacity(0.5))
                    .frame(width: 50, height: 50)
                    .scaleEffect(larger ? 3 : 1)
                    .animation(.easeInOut(duration: 2).repeatForever(), value: larger)
            }.onAppear {
                larger = false
            }
            
        }
    }
    
}
    


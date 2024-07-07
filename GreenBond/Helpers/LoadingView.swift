//  LoadingView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 21/6/2024.
//  Modified by FERREIRA Kévin on 21/6/2024.

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    
    let animation = Animation
        .linear(duration: 1)
        .repeatForever(autoreverses: false)
        .delay(0.5)
    
    var body: some View {
        if show{
            ZStack{
                AnimatedBlob(w: 150, h: 150, color: Color("mainColor").opacity(0.5))
                    .frame(width: 150, height: 150)
                
                AnimatedBlob(w: 100, h: 100, color: Color("mainColor"))
                    .frame(width: 100, height: 100)
            }
        }
    }
    
}



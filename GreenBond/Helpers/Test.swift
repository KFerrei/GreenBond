//
//  Test.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 13/7/2024.
//

import SwiftUI

struct Test: View {
    var body: some View {
        let a = CGFloat(200)
        VStack{

            Image(systemName: "book.circle")
                .resizable()
                .frame(width: a, height: a)
        }
        .frame(width: a+30, height: (a+30)*3)
        .background(Color(#colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)))
        .vAlign(.top)// #F8F8F8 in RGB
    }
    
    
}

#Preview {
    Test()
}

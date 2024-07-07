//
//  WorkshopCardView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 7/7/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct WorkshopCardView: View {
    var workshop: Workshop
    @Binding var openWorkshop: Bool
    @Binding var workshopToShow: Workshop?
    
    var body: some View {
            Button(action: {
                workshopToShow = workshop
                openWorkshop.toggle()
            }){
                ZStack{
                    WebImage(url: workshop.workshopURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .clipShape(Rectangle())
                        .contentShape(Rectangle())
                        .cornerRadius(10)
                    
                    Rectangle()
                        .fill(Color("mainColor").opacity(0.5))
                        .cornerRadius(10)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

                    Text(workshop.title)
                        .foregroundColor(.white)
                        .font(.headline)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
            }.frame(height: 100)
    }
}

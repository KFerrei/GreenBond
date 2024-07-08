//
//  MyWorkshopCardView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 8/7/2024.
//

import SwiftUI
import SDWebImageSwiftUI


struct MyWorkshopCardView: View {
    var workshop: UserWorkshop
    @Binding var userWorkshopToShow: UserWorkshop?
    
    var body: some View {
            Button(action: {
                if let userWorkshopToShow, userWorkshopToShow.workshopDateID == workshop.workshopDateID{
                    self.userWorkshopToShow = nil
                } else {
                    self.userWorkshopToShow = self.workshop
                }
            }){
                VStack{
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
                    .frame(width: 100, height: 100)
                    
                    Text(Functions.dateToString(date: workshop.date, form: "dd/MM/yy HH:mm"))
                        .italic()
                        .foregroundColor(.black)
                        .font(.footnote)
                        .frame(width: 100, height: 20)
                    
                    
                }
            }
    }
}

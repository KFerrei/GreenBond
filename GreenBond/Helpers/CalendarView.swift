//
//  CalendarView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 8/7/2024.
//

import SwiftUI

struct CalendarView: View {
    var workshopDates : [WorkshopDate]?
    @Binding var workshopDateSelected: WorkshopDate?
    @Binding var myProfile: User?
    
    
    var body: some View {
        if let wDates = workshopDates{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(wDates, id: \.self){ workshop in
                        Button(action:{workshopDateSelected = workshop}){
                            ZStack{
                                Rectangle()
                                    .fill(Color("mainColor"))
                                    .cornerRadius(10)
                                
                                VStack{
                                    if workshop.forPremium{
                                        Image(systemName: "crown.fill")
                                    }
                                    Text(Functions.dateToString(date: workshop.date, form: "dd/MM/yy"))
                                    Text(Functions.dateToString(date: workshop.date, form: "hh:mm"))
                                    Text("\(workshop.spot - workshop.userRegisterUID.count) spots")
                                }
                                
                            }
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                            .foregroundColor(.white)
                        }
                        .disableWithOpacity(isDisable(workshop: workshop))
                    }
                }
            }
            
            if let workshopDateSelected{
                HStack{
                    Text(Functions.dateToString(date: workshopDateSelected.date, form: "dd/MM/yy hh:mm"))
                        .bold()
                    
                    Text("\(workshopDateSelected.spot) spots left")
                        .italic()
                        .padding(.leading, 20)
                }
                .hAlign(.center)
            }
            
        }else {
            Text("There are no more spots left")
                .italic()
            
        }
    }
    func isDisable(workshop: WorkshopDate) -> Bool {
        let cond1 = (workshop.spot - workshop.userRegisterUID.count == 0)
        let cond2 = workshop.forPremium
        let cond3 = (Date() > myProfile!.userDatePremium)
        return cond1 || (cond2 && cond3)
    }
}


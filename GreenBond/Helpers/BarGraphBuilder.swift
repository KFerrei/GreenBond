//
//  BarGraphBuilder.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 23/6/2024.
//

import SwiftUI

struct BarGraphBuilder: View {
    var dataPoints: [Float]
    let monthNames: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var body: some View {
        Text("Progress")
            .font(.title.bold())
            .hAlign(.leading)
            .padding(15)
        
        let currentMonth = Int(Calendar.current.component(.month, from: Date()))
        
        HStack(spacing: 10) {
            ForEach(currentMonth-1..<currentMonth+7, id: \.self) { index in
                VStack {
                    Text("\(Int(dataPoints[index%12]))%")
                    Spacer()
                    Capsule()
                        .fill(AppColors.greenColor)
                        .frame(width: 30, height: CGFloat(dataPoints[index%12]))
                    
                    Text(monthNames[index%12])
                        .font(.caption)
                }
            }
        }
        .frame(height: 150)
        
    }
}


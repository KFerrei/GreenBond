//
//  BarGraphBuilder.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 23/6/2024.
//

import SwiftUI

struct BarGraphBuilder: View {
    var dataPoints: [Float]
    
    var body: some View {
        Text("Progress")
            .font(.title.bold())
            .hAlign(.leading)
            .padding(15)
        
        let currentMonth = Int(Calendar.current.component(.month, from: Date()))-1
        
        HStack(spacing: 10) {
            ForEach(currentMonth-5 ..< (currentMonth)+1, id: \.self) { index in
                VStack {
                    Text("\(Int(dataPoints[abs(index%12)]))%")
                    Spacer()
                    Capsule()
                        .fill(AppColors.greenColor)
                        .frame(width: 30, height: CGFloat(dataPoints[abs(index%12)]))
                    Spacer()
                    Text(AppConstants.Lists.months[abs(index%12)])
                        .rotationEffect(.degrees(-45))
                        .font(.caption)
                }
            }
        }
        .frame(height: 200)
        
    }
}


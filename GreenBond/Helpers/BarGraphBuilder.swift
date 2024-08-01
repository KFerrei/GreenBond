//
//  BarGraphBuilder.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 23/6/2024.
//

import SwiftUI

struct BarGraphBuilder: View {
    var dataPoints: [Float]
    var progressValue: [Float]
    
    var body: some View {
        Text("progress")
            .font(.title)
            .hAlign(.leading)
            .padding(15)
        
        let currentMonth = Int(Calendar.current.component(.month, from: Date()))-1
        
        HStack(spacing: 10) {
            ForEach(currentMonth-5 ..< (currentMonth)+1, id: \.self) { index in
                ZStack {
                    VStack {
                        Text("\(Int(ceil(dataPoints[abs(index%12)])))%")
                            .font(.caption)
                        Spacer()
                        Capsule()
                            .fill(Color("mainColor").opacity(0.5))
                            .frame(width: 30, height: 1.4*CGFloat(dataPoints[abs(index%12)]))
                            .padding(.bottom, 10)
                        Text(AppConstants.Lists.months[abs(index%12)].prefix(3))
                            .font(.caption)
                    }.frame(height: 200)
                    
                    Image(systemName: "face.smiling")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .offset(y: -(CGFloat(progressValue[abs(index%12)])-0.5) * 120)
                        .zIndex(1)
                    
                }
            }
        }.frame(height: 200)
        
    }
}


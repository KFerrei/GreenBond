//
//  AnimatedBlob.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 7/7/2024.
//

import SwiftUI

struct AnimatedBlob: View {
    @State var appear = false
    var w : CGFloat = CGFloat(100)
    var h : CGFloat = CGFloat(100)
    var color : Color = Color("mainColor")
    
    var body: some View {
        TimelineView(.animation()) { timeline in
                Canvas { context, size in
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    let angle1 = cos(Angle.degrees(now.remainder(dividingBy: 3)*20).radians)
                    let angle2 = cos(Angle.degrees(now.remainder(dividingBy: 4)*25).radians)
                                
                    var path = Path()
                    
                    path.move(to: CGPoint(x: 0.9419*w*angle1, y: 0.4798*h*angle2))
                    
                    path.addCurve(to: CGPoint(x: 0.6313*w*angle1, y: h*angle2), control1: CGPoint(x: 0.8838*w*angle1, y: 0.7984*h*angle2), control2: CGPoint(x: 0.8778*w*angle1, y: h*angle2))
                    
                    path.addCurve(to: CGPoint(x: 0.1563*w*angle2, y: 0.6391*h*angle2), control1: CGPoint(x: 0.3848*w*angle1, y: h*angle2), control2: CGPoint(x: 0.3126*w*angle2, y: 0.7944*h*angle1))
                    

                    path.addCurve(to: CGPoint(x:0.3747*w*angle2 , y: 0.1512*h*angle1), control1: CGPoint(x: angle1, y: 0.4839*h*angle2), control2: CGPoint(x: 0.0802*w*angle1, y: 0.3024*h*angle2))
                    
                    path.addCurve(to: CGPoint(x: 0.9419*w*angle1, y: 0.4798*h*angle2), control1: CGPoint(x: 0.6693*w*angle2, y: angle1 ), control2: CGPoint(x: w*angle1, y: 0.1613*h*angle2))
                    
                    path.closeSubpath()
                    
                    context.fill(path, with: .color(Color(color)))
                }
                .frame(alignment: .center)
            }
        .scaleEffect(appear ? 1 : 0.8)
            .animation(.easeInOut(duration: 10).repeatForever(), value:appear)
            .onAppear {
                appear = true
            }

    }
}
#Preview{
    AnimatedBlob()
}

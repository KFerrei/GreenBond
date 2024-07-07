//
//  WaveShape.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 23/6/2024.
//

import SwiftUI

struct WaveShape: Shape {
    var points: [(CGPoint, CGPoint, CGPoint)]

    func path(in rect: CGRect) -> Path {
        
        let w = rect.width
        let h = rect.height
        
        var path = Path()

        // Commencer par la première ligne droite
        path.move(to: CGPoint(x:points[0].0.x, y:points[0].0.y))
        // Ajouter des vagues pour les points intermédiaires
        for i in stride(from: 0, to: points.count, by: 1) {
            path.addCurve(to: CGPoint(x: w * points[i].0.x, y: h * points[i].0.y), control1: CGPoint(x: w *  points[i].1.x, y: h * points[i].1.y) , control2: CGPoint(x: w * points[i].2.x, y: h * points[i].2.y))
        }

        //path.closeSubpath()

        return path
    }
}

struct WaveShapePoint {
    static let points_Up1 = [
        (CGPoint(x:0.08, y:0.00), CGPoint(x:0.08, y:0.00), CGPoint(x:0.08, y:0.00)),
        (CGPoint(x:1.00, y:0.00), CGPoint(x:1.00, y:0.00), CGPoint(x:1.00, y:0.00)),
        (CGPoint(x:1.00, y:0.66), CGPoint(x:1.00, y:0.66), CGPoint(x:1.00, y:0.66)),
        (CGPoint(x:0.80, y:0.66), CGPoint(x:1.00, y:0.66), CGPoint(x:0.95, y:1.00)),
        (CGPoint(x:0.47, y:0.55), CGPoint(x:0.71, y:0.47), CGPoint(x:0.55, y:0.47)),
        (CGPoint(x:0.18, y:0.28), CGPoint(x:0.29, y:0.70), CGPoint(x:0.26, y:0.32)),
        (CGPoint(x:0.01, y:0.13), CGPoint(x:0.10, y:0.26), CGPoint(x:0.01, y:0.21)),
        (CGPoint(x:0.08, y:0.00), CGPoint(x:0.00, y:0.04), CGPoint(x:0.08, y:0.00))
    ]
    
    
    static let points_Down1 = [
        (CGPoint(x:0.00, y:1.00), CGPoint(x:0.00, y:1.00), CGPoint(x:0.00, y:1.00)),
        (CGPoint(x:0.00, y:0.00), CGPoint(x:0.00, y:0.00), CGPoint(x:0.00, y:0.00)),
        (CGPoint(x:0.52, y:0.11), CGPoint(x:0.32, y:0.47), CGPoint(x:0.41, y:0.16)),
        (CGPoint(x:0.75, y:0.46), CGPoint(x:0.64, y:0.05), CGPoint(x:0.78, y:0.23)),
        (CGPoint(x:0.95, y:0.86), CGPoint(x:0.72, y:0.68), CGPoint(x:0.9, y:0.77)),
        (CGPoint(x:0.71, y:1.00), CGPoint(x:1.00, y:0.96), CGPoint(x:0.71, y:1.00)),
        (CGPoint(x:0.00, y:1.00), CGPoint(x:0.00, y:1.00), CGPoint(x:0.00, y:1.00))
    ]
    
    static let points_Up2 = [
        (CGPoint(x:0.00, y:0.00), CGPoint(x:0.00, y:0.00), CGPoint(x:0.00, y:0.00)),
        (CGPoint(x:1.00, y:0.00), CGPoint(x:1.00, y:0.00), CGPoint(x:1.00, y:0.00)),
        (CGPoint(x:1.00, y:0.63), CGPoint(x:1.00, y:0.63), CGPoint(x:1.00, y:0.63)),
        (CGPoint(x:0.58, y:0.85), CGPoint(x:1.00, y:0.63), CGPoint(x:0.73, y:1.00)),
        (CGPoint(x:0.15, y:0.51), CGPoint(x:0.43, y:0.71), CGPoint(x:0.16, y:0.00)),
        (CGPoint(x:0.00, y:0.37), CGPoint(x:0.14, y:0.78), CGPoint(x:0.00, y:0.37)),
        (CGPoint(x:0.00, y:0.00), CGPoint(x:0.00, y:0.37), CGPoint(x:0.00, y:0.00))]
    
    static let points_Down2 = [
        (CGPoint(x:1.00, y:1.00), CGPoint(x:1.00, y:1.00), CGPoint(x:1.00, y:1.00)),
        (CGPoint(x:0.14, y:1.00), CGPoint(x:0.14, y:1.00), CGPoint(x:0.14, y:1.00)),
        (CGPoint(x:0.14, y:0.61), CGPoint(x:0.14, y:1.00), CGPoint(x:0.00, y:0.80)),
        (CGPoint(x:0.37, y:0.67), CGPoint(x:0.28, y:0.43), CGPoint(x:0.31, y:0.76)),
        (CGPoint(x:0.56, y:0.27), CGPoint(x:0.43, y:0.61), CGPoint(x:0.49, y:0.31)),
        (CGPoint(x:0.74, y:0.27), CGPoint(x:0.62, y:0.24), CGPoint(x:0.60, y:0.55)),
        (CGPoint(x:1.00, y:0.27), CGPoint(x:0.88, y:0.00), CGPoint(x:1.00, y:0.18)),
        (CGPoint(x:1.00, y:1.00), CGPoint(x:1.00, y:0.80), CGPoint(x:1.00, y:1.00))]

}

#Preview {
    WaveShape(points: WaveShapePoint.points_Down2)
        .fill(AppColors.greenColor)
        .frame(width: 300, height: 300)
}

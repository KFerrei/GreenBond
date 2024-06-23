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
        var path = Path()

        // Commencer par la première ligne droite
        path.move(to: points[0].0)
        // Ajouter des vagues pour les points intermédiaires
        for i in stride(from: 0, to: points.count, by: 1) {
            path.addCurve(to: points[i].0, control1: points[i].1 , control2: points[i].2)
        }

        path.closeSubpath()

        return path
    }
}

struct WaveShapePoint {
    static let points_Up1 = [
        (CGPoint(x: 48.5, y: 0.5), CGPoint(x: 48.5, y: 0.5), CGPoint(x: 48.5, y: 0.5)),
        (CGPoint(x: 499.5, y: 0.5), CGPoint(x: 499.5, y: 0.5), CGPoint(x: 499.5, y: 0.5)),
        (CGPoint(x: 499.5, y: 155.5), CGPoint(x: 499.5, y: 155.5), CGPoint(x: 499.5, y: 155.5)),
        (CGPoint(x: 398.5, y: 155.5), CGPoint(x: 499.5, y: 155.5), CGPoint(x: 474.26, y: 236.94)),
        (CGPoint(x: 239.5, y: 129.5), CGPoint(x: 358.5, y: 112.5), CGPoint(x: 281.5, y: 112.5)),
        (CGPoint(x: 99.5, y: 65.5), CGPoint(x: 150.52, y: 165.51), CGPoint(x: 137.5, y: 73.5)),
        (CGPoint(x: 13.5, y: 30.5), CGPoint(x: 61.5, y: 60.5), CGPoint(x: 14.5, y: 50.5)),
        (CGPoint(x: 48.5, y: 0.5), CGPoint(x: 12.5, y: 10.5), CGPoint(x: 48.5, y: 0.5))
    ]
    
    
    static let points_Down1 = [
        (CGPoint(x: 0.5, y: 272.5), CGPoint(x: 0.5, y: 272.5), CGPoint(x: 0.5, y: 272.5)),
        (CGPoint(x: 0.5, y: 47.5), CGPoint(x: 0.5, y: 47.5), CGPoint(x: 0.5, y: 47.5)),
        (CGPoint(x: 70.5, y: 47.5), CGPoint(x: 0.5, y: 47.5), CGPoint(x: 13.5, y: -58.5)),
        (CGPoint(x: 208.5, y: 72.5), CGPoint(x: 127.5, y: 153.5), CGPoint(x: 161.5, y: 84.5)),
        (CGPoint(x: 297.5, y: 152.5), CGPoint(x: 255.5, y: 60.5), CGPoint(x: 309.5, y: 100.5)),
        (CGPoint(x: 396.5, y: 243.5), CGPoint(x: 285.5, y: 204.5), CGPoint(x: 395.5, y: 221.5)),
        (CGPoint(x: 280.5, y: 272.5),CGPoint(x: 397.5, y: 265.5), CGPoint(x: 280.5, y: 272.5)),
        (CGPoint(x: 0.5, y: 272.5), CGPoint(x: 0.5, y: 272.5), CGPoint(x: 0.5, y: 272.5))
    ]
    
    static let points_Up2 = [
        (CGPoint(x: 0.5, y: 0.68), CGPoint(x: 0.5, y: 0.68), CGPoint(x: 0.5, y: 0.68)),
        (CGPoint(x: 499.5, y: 0.68), CGPoint(x: 499.5, y: 0.68), CGPoint(x: 499.5, y: 0.68)),
        (CGPoint(x: 499.5, y: 128.1), CGPoint(x: 499.5, y: 128.1), CGPoint(x: 499.5, y: 128.1)),
        (CGPoint(x: 290.5, y: 175.5),CGPoint(x: 499.5, y: 128.1), CGPoint(x: 364.5, y: 207.07)),
        (CGPoint(x: 73.5, y: 104.5), CGPoint(x: 216.5, y: 143.93), CGPoint(x: 81.02, y: 2.98)),
        (CGPoint(x: 0.5, y: 75.1), CGPoint(x: 69.5, y: 158.5), CGPoint(x: 0.5, y: 74.92)),
        (CGPoint(x: 0.5, y: 0.68), CGPoint(x: 0.5, y: 75.5), CGPoint(x: 0.5, y: 0.68))]
    
    static let points_Down2 = [
        (CGPoint(x: 499.5, y: 250.5), CGPoint(x: 499.5, y: 250.5), CGPoint(x: 499.5, y: 250.5)),
        (CGPoint(x: 105.5, y: 250.5), CGPoint(x: 105.5, y: 250.5), CGPoint(x: 105.5, y: 250.5)),
        (CGPoint(x: 105.5, y: 155.5), CGPoint(x: 105.5, y: 250.5), CGPoint(x: 42.5, y: 198.5)),
        (CGPoint(x: 211.5, y: 171.5), CGPoint(x: 168.5, y: 112.5), CGPoint(x: 186.5, y: 187.5)),
        (CGPoint(x: 298.5, y: 73.5), CGPoint(x: 236.5, y: 155.5), CGPoint(x: 268.5, y: 79.5)),
        (CGPoint(x: 382.5, y: 73.5), CGPoint(x: 328.5, y: 67.5), CGPoint(x: 319.5, y: 139.5)),
        (CGPoint(x: 499.5, y: 73.5), CGPoint(x: 445.5, y: 7.5), CGPoint(x: 499.5, y: -50.5)),
        (CGPoint(x: 499.5, y: 250.5), CGPoint(x: 499.5, y: 197.5), CGPoint(x: 499.5, y: 250.5))]
}

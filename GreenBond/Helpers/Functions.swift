//
//  Functions.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 4/7/2024.
//

import SwiftUI

struct Functions {
    
    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Définir le format de date souhaité
        return dateFormatter.string(from: date)
    }
    
    static func dateHoursToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy HH:mm" // Définir le format de date souhaité
        return dateFormatter.string(from: date)
    }
    
    static func stringToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Le même format que celui utilisé pour convertir en String
        return dateFormatter.date(from: string)
    }
    
    static func dayToString(date: Date) -> String {
        let dateForm = DateFormatter()
        dateForm.dateFormat = "dd/MM/yy"
        return dateForm.string(from: Date())
    }
}


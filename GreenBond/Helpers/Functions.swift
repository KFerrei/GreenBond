//
//  Functions.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 7/7/2024.
//

import SwiftUI

struct Functions {
    
    static func dateToString(date: Date, form: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = form
        return dateFormatter.string(from: date)
    }
    
    static func stringToDate(string: String, form: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = form
        return dateFormatter.date(from: string)
    }
}

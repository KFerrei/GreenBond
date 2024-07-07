//
//  Workshop.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 6/7/2024.
//

import SwiftUI
import FirebaseFirestore


struct Workshop: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var organizer: String
    var adress: String
    var city: String
    var price : Float
    var theme1: String
    var theme2: String = ""
    var dates: [Date]
    var spots: [Int]
    var userUIDs: [[String]]
    var workshopURL: URL?
    var workshopImageID: String?
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case description
        case organizer
        case adress
        case city
        case price
        case theme1
        case theme2
        case dates
        case spots
        case userUIDs
        case workshopURL
        case workshopImageID
    }
}

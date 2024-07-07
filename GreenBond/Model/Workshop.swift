//
//  Workshop.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 6/7/2024.
//

import SwiftUI
import FirebaseFirestore


struct Workshop: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var organizer: String
    var adress: String
    var city: String
    var price : Double
    var theme1: String
    var theme2: String = ""
    var workshopDates: [WorkshopDate]
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
        case workshopDates
        case workshopURL
        case workshopImageID
    }
    
    init(id: String? = nil, title: String, description: String, organizer: String, adress: String, city: String, price : Double, theme1: String, theme2: String = "", workshopDates: [WorkshopDate], workshopURL: URL?, workshopImageID: String?){
        self.id = id
        self.title = title
        self.description = description
        self.organizer = organizer
        self.adress = adress
        self.city = city
        self.price = price
        self.theme1 = theme1
        self.theme2 = theme2
        self.workshopDates = workshopDates
        self.workshopURL = workshopURL
        self.workshopImageID = workshopImageID
    }
    
    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        organizer = try container.decode(String.self, forKey: .organizer)
        adress = try container.decode(String.self, forKey: .adress)
        city = try container.decode(String.self, forKey: .city)
        price = try container.decode(Double.self, forKey: .price)
        theme1 = try container.decode(String.self, forKey: .theme1)
        theme2 = try container.decode(String.self, forKey: .theme2)
        workshopDates = try container.decode([WorkshopDate].self, forKey: .workshopDates)
        workshopURL = try container.decode(URL?.self, forKey: .workshopURL)
        workshopImageID = try container.decode(String?.self, forKey: .workshopImageID)

    }
    
    // Custom encode function that encodes the DocumentID property using the Firestore.Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let id = id {
            let firestoreEncoder = Firestore.Encoder()
            let something = try firestoreEncoder.encode(["id":id])
            
            if let mapId = something["id"] as? String {
                try container.encode(mapId, forKey: .id)
            }
        }

        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(organizer, forKey: .organizer)
        try container.encode(adress, forKey: .adress)
        try container.encode(city, forKey: .city)
        try container.encode(price, forKey: .price)
        try container.encode(theme1, forKey: .theme1)
        try container.encode(theme2, forKey: .theme2)
        try container.encode(workshopDates, forKey: .workshopDates)
        try container.encode(workshopURL, forKey: .workshopURL)
        try container.encode(workshopImageID, forKey: .workshopImageID)

    }
}

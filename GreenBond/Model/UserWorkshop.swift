//
//  UserWorkshop.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 8/7/2024.
//

import SwiftUI
import FirebaseFirestore


struct UserWorkshop: Identifiable, Codable, Hashable  {
    @DocumentID var id: String?
    var workshopID : String
    var workshopDateID : String
    var title: String
    var organizer: String
    var adress: String
    var city: String
    var workshopURL: URL
    var date: Date
    var pricePayed: Double
    var gpUsed : Int
    
    enum CodingKeys: CodingKey {
        case id
        case workshopID
        case workshopDateID
        case title
        case organizer
        case adress
        case city
        case workshopURL
        case date
        case pricePayed
        case gpUsed
    }
    
    init(id: String? = nil, workshopID: String, workshopDateID: String, title: String, organizer: String, adress: String, city: String, workshopURL: URL, date: Date, pricePayed: Double, gpUsed: Int){
        self.id = id
        self.workshopID = workshopID
        self.workshopDateID = workshopDateID
        self.title = title
        self.organizer = organizer
        self.adress = adress
        self.city = city
        self.workshopURL = workshopURL
        self.date = date
        self.pricePayed = pricePayed
        self.gpUsed = gpUsed
    }
    
    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        workshopID = try container.decode(String.self, forKey: .workshopID)
        workshopDateID = try container.decode(String.self, forKey: .workshopDateID)
        title = try container.decode(String.self, forKey: .title)
        organizer = try container.decode(String.self, forKey: .organizer)
        adress = try container.decode(String.self, forKey: .adress)
        city = try container.decode(String.self, forKey: .city)
        workshopURL = try container.decode(URL.self, forKey: .workshopURL)
        date = try container.decode(Date.self, forKey: .date)
        pricePayed = try container.decode(Double.self, forKey: .pricePayed)
        gpUsed = try container.decode(Int.self, forKey: .gpUsed)
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

        try container.encode(workshopID, forKey: .workshopID)
        try container.encode(workshopDateID, forKey: .workshopDateID)
        try container.encode(title, forKey: .title)
        try container.encode(organizer, forKey: .organizer)
        try container.encode(adress, forKey: .adress)
        try container.encode(city, forKey: .city)
        try container.encode(workshopURL, forKey: .workshopURL)
        try container.encode(date, forKey: .date)
        try container.encode(pricePayed, forKey: .pricePayed)
        try container.encode(gpUsed, forKey: .gpUsed)

    }
}


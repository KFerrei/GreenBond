//
//  WorkshopDate.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 7/7/2024.
//

import SwiftUI
import FirebaseFirestore


struct WorkshopDate: Identifiable, Codable, Hashable  {
    @DocumentID var id: String?
    var date: Date
    var spot: Int
    var userRegisterUID: [String]
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case spot
        case userRegisterUID
    }
    
    init(id: String? = nil, date: Date, spot: Int, userRegisterUID: [String]){
        self.id = id
        self.date = date
        self.spot = spot
        self.userRegisterUID = userRegisterUID
    }
    
    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        spot = try container.decode(Int.self, forKey: .spot)
        userRegisterUID = try container.decode([String].self, forKey: .userRegisterUID)
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

        try container.encode(date, forKey: .date)
        try container.encode(spot, forKey: .spot)
        try container.encode(userRegisterUID, forKey: .userRegisterUID)

    }
}


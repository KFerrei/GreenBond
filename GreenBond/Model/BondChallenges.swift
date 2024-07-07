//
//  BondChallenges.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 3/7/2024.
//

import SwiftUI
import FirebaseFirestore

struct BondChallenges: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var text: String
    
    var month: Int
    var greenPoints: Int
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case month
        case greenPoints
    }
    
    init(id: String? = nil, text: String, month: Int, greenPoints: Int, bondUID: String){
        self.id = id
        self.text = text
        self.month = month
        self.greenPoints = greenPoints
    }
    
    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(DocumentID<String>.self, forKey: .id).wrappedValue
        text = try container.decode(String.self, forKey: .text)
        month = try container.decode(Int.self, forKey: .month)
        greenPoints = try container.decode(Int.self, forKey: .greenPoints)
    }
    
    // Custom encode function that encodes the DocumentID property using the Firestore.Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the DocumentID property using the Firestore.Encoder
        if let id = id {
            let firestoreEncoder = Firestore.Encoder()
            let something = try firestoreEncoder.encode(["id":id])
            
            if let mapId = something["id"] as? String {
                try container.encode(mapId, forKey: .id)
            }
        }
        
        
        try container.encode(text, forKey: .text)
        try container.encode(month, forKey: .month)
        try container.encode(greenPoints, forKey: .greenPoints)
    }

}

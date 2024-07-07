//
//  LearnPost.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 2/7/2024.
//

import SwiftUI
import FirebaseFirestore

// MARK: Post Model
struct LearnPost: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var text: String
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case publishedDate
        case likedIDs
    }
    
    init(id: String? = nil, text: String, publishedDate: Date = Date(), likedIDs: [String] = []){
        self.id = id
        self.text = text
        self.publishedDate = publishedDate
        self.likedIDs = likedIDs
    }
    
    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(DocumentID<String>.self, forKey: .id).wrappedValue
        text = try container.decode(String.self, forKey: .text)
        publishedDate = try container.decode(Date.self, forKey: .publishedDate)
        likedIDs = try container.decode([String].self, forKey: .likedIDs)
        
        // Decode the DocumentID property using the Firestore.Decoder
        if let idContainer = try? decoder.container(keyedBy: CodingKeys.self),
           let id = try? idContainer.decode(String.self, forKey: .id) {
            self.id = id
        }
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
        try container.encode(publishedDate, forKey: .publishedDate)
        try container.encode(likedIDs, forKey: .likedIDs)

        
    }

}

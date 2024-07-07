//
//  Comment.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 5/7/2024.
//

import SwiftUI
import FirebaseFirestore



struct Comment: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var challengeID : String
    var userID : String
    var text: String
    var date: Date
    var commentURL: URL?
    var commentImageID: String?
    
    enum CodingKeys: CodingKey {
        case id
        case challengeID
        case userID
        case text
        case date
        case commentURL
        case commentImageID
    }
    
    init(id: String? = nil, challengeID: String, userID: String, text: String, date: Date = Date(), commentURL: URL?=nil, commentImageID: String = ""){
        self.id = id
        self.challengeID = challengeID
        self.userID = userID
        self.text = text
        self.date = date
        self.commentURL = commentURL
        self.commentImageID = commentImageID
    }
    
    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        challengeID = try container.decode(String.self, forKey: .challengeID)
        userID = try container.decode(String.self, forKey: .userID)
        text = try container.decode(String.self, forKey: .text)
        date = try container.decode(Date.self, forKey: .date)
        commentURL = try? container.decode(URL?.self, forKey: .commentURL)
        commentImageID = try? container.decode(String?.self, forKey: .commentImageID)
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
        
        try container.encode(challengeID, forKey: .challengeID)
        try container.encode(userID, forKey: .userID)
        try container.encode(text, forKey: .text)
        try container.encode(date, forKey: .date)
        try container.encode(commentURL, forKey: .commentURL)
        try container.encode(commentImageID, forKey: .commentImageID)
    }

}

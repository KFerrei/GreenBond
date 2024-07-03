//
//  LearnPost.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 2/7/2024.
//

import SwiftUI
import FirebaseFirestoreSwift

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
}

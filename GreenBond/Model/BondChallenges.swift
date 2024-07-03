//
//  BondChallenges.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 3/7/2024.
//

import SwiftUI
import FirebaseFirestoreSwift

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
}

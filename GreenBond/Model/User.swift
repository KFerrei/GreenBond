//  User.swift
//  GreenBond
//  Created by FERREIRA Kévin on 21/6/2024.
//  Modified by FERREIRA Kévin on 21/6/2024.

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable{
    @DocumentID var id: String?
    var userGender: String
    var userGivenName: String
    var userFamilyName: String
    var userName: String
    var userProfileURL: URL
    
    var userCity: String
    var userBirthDate: Date
    
    var userEmail: String
    
    var userRegisterDate: Date
    var userDatePremium: Date
    
    var userUID: String
    
    var userProgress: [Float]
    var isAdmin: Bool
    
    enum CodingKeys: CodingKey{
        case id
        case userGender
        case userGivenName
        case userFamilyName
        case userName
        case userProfileURL
        case userCity
        case userBirthDate
        case userEmail
        case userRegisterDate
        case userDatePremium
        case userUID
        case userProgress
        case isAdmin
    }
    
}

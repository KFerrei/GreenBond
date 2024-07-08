//  User.swift
//  GreenBond
//  Created by FERREIRA Kévin on 21/6/2024.
//  Modified by FERREIRA Kévin on 21/6/2024.

import SwiftUI
import FirebaseFirestore

struct User: Identifiable, Codable, Equatable, Hashable{
    @DocumentID var id: String?
    var userGender: String
    var userGivenName: String
    var userFamilyName: String
    var userProfileURL: URL
    var userCity: String
    var userBirthDate: Date
    var userEmail: String
    var userRegisterDate: Date
    var userDatePremium: Date
    var userGreenCoins: Int
    var userUID: String
    var userProgress: [Float]
    var isAdmin: Bool
    var myWorkshops : [UserWorkshop]
    
    
    enum CodingKeys: CodingKey{
        case id
        case userGender
        case userGivenName
        case userFamilyName
        case userProfileURL
        case userCity
        case userBirthDate
        case userEmail
        case userRegisterDate
        case userDatePremium
        case userGreenCoins
        case userUID
        case userProgress
        case isAdmin
        case myWorkshops
        
    }
    
    init(id: String? = nil, userGender: String, userGivenName: String, userFamilyName: String, userProfileURL: URL, userCity: String, userBirthDate: Date, userEmail: String, userRegisterDate: Date = Date(), userDatePremium: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date())!, userGreenCoins: Int = 0, userUID: String, userProgress: [Float] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], isAdmin: Bool = false, myWorkshops: [UserWorkshop] = []){
        self.id = id
        self.userGender = userGender
        self.userGivenName = userGivenName
        self.userFamilyName = userFamilyName
        self.userProfileURL = userProfileURL
        self.userCity = userCity
        self.userBirthDate = userBirthDate
        self.userEmail = userEmail
        self.userRegisterDate = userRegisterDate
        self.userDatePremium = userDatePremium
        self.userGreenCoins = userGreenCoins
        self.userUID = userUID
        self.userProgress = userProgress
        self.isAdmin = isAdmin
        self.myWorkshops = myWorkshops
    }
    
    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        userGender = try container.decode(String.self, forKey: .userGender)
        userGivenName = try container.decode(String.self, forKey: .userGivenName)
        userFamilyName = try container.decode(String.self, forKey: .userFamilyName)
        userProfileURL = try container.decode(URL.self, forKey: .userProfileURL)
        userCity = try container.decode(String.self, forKey: .userCity)
        userBirthDate = try container.decode(Date.self, forKey: .userBirthDate)
        userEmail = try container.decode(String.self, forKey: .userEmail)
        userRegisterDate = try container.decode(Date.self, forKey: .userRegisterDate)
        userDatePremium = try container.decode(Date.self, forKey: .userDatePremium)
        userGreenCoins = try container.decode(Int.self, forKey: .userGreenCoins)
        userUID = try container.decode(String.self, forKey: .userUID)
        userProgress = try container.decode([Float].self, forKey: .userProgress)
        isAdmin = try container.decode(Bool.self, forKey: .isAdmin)
        myWorkshops = try container.decode([UserWorkshop].self, forKey: .myWorkshops)
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
        
        try container.encode(userGender, forKey: .userGender)
        try container.encode(userGivenName, forKey: .userGivenName)
        try container.encode(userFamilyName, forKey: .userFamilyName)
        try container.encode(userProfileURL, forKey: .userProfileURL)
        try container.encode(userCity, forKey: .userCity)
        try container.encode(userBirthDate, forKey: .userBirthDate)
        try container.encode(userEmail, forKey: .userEmail)
        try container.encode(userRegisterDate, forKey: .userRegisterDate)
        try container.encode(userDatePremium, forKey: .userDatePremium)
        try container.encode(userGreenCoins, forKey: .userGreenCoins)
        try container.encode(userUID, forKey: .userUID)
        try container.encode(userProgress, forKey: .userProgress)
        try container.encode(isAdmin, forKey: .isAdmin)
        try container.encode(myWorkshops, forKey: .myWorkshops)
    }
    
    mutating func sortWorkshopsByDate() ->  [UserWorkshop]{
           return myWorkshops.sorted { $0.date < $1.date }
       }
    
}

//
//  GreenBondApp.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 20/6/2024.
//

import SwiftUI
import Firebase

@main
struct GreenBondApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

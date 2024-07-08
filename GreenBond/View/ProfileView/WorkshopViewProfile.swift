//
//  WorkshopViewProfile.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 8/7/2024.
//

import SwiftUI

struct WorkshopViewProfile: View {
    @Binding var myProfile: User?
    var workshop: UserWorkshop?
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


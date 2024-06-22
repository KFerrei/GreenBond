//  ContentView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 20/6/2024.
//  Modified by FERREIRA Kévin on 20/6/2024.

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        if logStatus{
            MainView()
        }else{
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}

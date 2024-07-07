//
//  WorkshopView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 7/7/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage


struct WorkshopView: View {
    
    @Binding var myProfile: User?
    var workshop: Workshop?
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Button("Cancel", role: .destructive){
                    dismiss()
                }
                .font(.callout)
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .hAlign(.leading)
                
            }
            .hAlign(.center)
            .padding (.horizontal, 15)
            .padding(.vertical,10)
            .background{
                Rectangle()
                    .fill(Color("mainColor"))
                    .ignoresSafeArea()
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    
                    Text(workshop!.title)
                        .font(.title.bold())
                        .padding(.top, 20)
                        .multilineTextAlignment(.center)
                    
                    Text("by \(workshop!.organizer)")
                        .italic()
                    
                    GeometryReader { geometry in
                        WebImage(url: workshop!.workshopURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: 200)
                            .clipShape(Rectangle())
                            .contentShape(Rectangle())
                            .cornerRadius(10)
                    }
                    .frame(height: 215)
                    .padding(.vertical, 10)
                    
                    let components = workshop!.description.split(separator: "/h")
                    let mainDescription = components.first?.trimmingCharacters(in: .whitespaces) ?? ""
                    let highlights = components.dropFirst().map { $0.trimmingCharacters(in: .whitespaces) }
                    
                    Text("Description :")
                        .font(.headline.bold())
                        .hAlign(.leading)
                    
                    Text(mainDescription)
                        .font(.body)
                        .hAlign(.leading)
                    
                    Text("Highlights :")
                        .font(.headline.bold())
                        .hAlign(.leading)
                        .padding(.top, 5)
                    
                    VStack(spacing: 2){
                        ForEach(highlights, id: \.self) { highlight in
                            Text(" ✓ \(highlight)")
                                .font(.body)
                                .hAlign(.leading)
                        }
                    }
                    .padding(.leading, 10)
                    
                    Text("Adress :")
                        .font(.headline.bold())
                        .hAlign(.leading)
                        .padding(.top, 5)
                    Text(workshop!.adress)
                        .font(.body)
                        .hAlign(.center)
                    Text(workshop!.city)
                        .font(.body)
                        .hAlign(.center)
                    
                    Text("Price :")
                        .font(.headline.bold())
                        .hAlign(.leading)
                        .padding(.top, 5)
                    
                    Text("\(String(workshop!.price)) €")
                        .font(.body)
                        .hAlign(.center)
                    
                    Button(action: {}){
                        Text("register for this workshop")
                            .foregroundColor(.white)
                            .hAlign(.center)
                            .fillView(Color("mainColor"))
                    }
                    //.disableWithOpacity(isFormValid())
                    .padding(.top, 10)
                    
                }
            }
            .padding(.horizontal, 20)
            .vAlign(.top)
            .alert(errorMessage, isPresented: $showError, actions: {})
            .overlay{
                LoadingView(show: $isLoading)
            }
        }
    }
    
    
    func updateUser(){
        do {
            myProfile?.userGreenCoins = myProfile!.userGreenCoins

            let doc = Firestore.firestore().collection("Users").document(myProfile!.userUID)
            
            try doc.setData(from: myProfile, completion : {error in
                if error == nil{
                    isLoading = false
                    dismiss()
                }
            })
        } catch {
            print("erreur")
            
        }
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

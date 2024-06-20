//
//  RegisterView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 20/6/2024.
//

import SwiftUI

struct RegisterView: View {
    
    @State var emailID : String = ""
    @State var password: String = ""
    @State var userGender: String = ""
    @State var userGivenName: String = ""
    @State var userFamilyName: String = ""
    @State var userBirthDate: Date = Date()
    @State var userCity: String = ""
    @State var userProfilePicData : Data?
    
    @Environment(\.dismiss) var dismiss
    
    let genders = ["man", "women", "other"]
    let cities = ["Berlin, Germany", "Paris, France"]
    
    var body: some View {
        ZStack {

            Circle()
                .fill(Color(hex: "105b37"))
                .frame(width: 300, height: 300)
                .offset(x: 100, y: 300)
                .zIndex(0)
            
            VStack(spacing: 10){
                Text("registration")
                    .font(.system(size: 50).bold())
                    .hAlign(.center)
                
                VStack(spacing: 10){
                    ZStack{
                        if let userProfilePicData, let image = UIImage(data: userProfilePicData){
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }else{
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color(hex: "105b37"))
                        }
                        
                    }
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .frame(width: 85, height: 85)
                    .padding(.top, 10)

                    
                    Picker("gender", selection: $userGender){
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    .hAlign(.leading)
                    .tint(.black)
                    .border(1, .gray.opacity(0.5))
                    
                    TextField("given name", text: $userGivenName)
                        .textContentType(.givenName)
                        .border(1, .gray.opacity(0.5))
                        
                    
                    TextField("family name", text: $userFamilyName)
                        .textContentType(.familyName)
                        .border(1, .gray.opacity(0.5))
                    
                    TextField("email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                    
                    SecureField("password", text: $password)
                        .textContentType(.password)
                        .border(1, .gray.opacity(0.5))
                    
                    DatePicker("birth date", selection: $userBirthDate, displayedComponents: [.date])
                        .foregroundColor(.gray.opacity(0.5))
                        .border(1, .gray.opacity(0.5))
                    
                    Picker("city", selection: $userCity){
                        ForEach(cities, id: \.self) {
                            Text($0)
                        }
                    }
                    .hAlign(.leading)
                    .tint(.black)
                    .textContentType(.addressCityAndState)
                    .border(1, .gray.opacity(0.5))
                
                    
                    Button{
                        
                    } label: {
                        Text("sign up")
                            .foregroundColor(.white)
                            .hAlign(.center)
                            .fillView(.black)
                    }.padding(.top, 10)

                    
                }
                
                HStack{
                    Text("already have an account?")
                    
                    Button("login now"){
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    
                }
                .hAlign(.center)
                .vAlign(.bottom)
                
            }
            .vAlign(.center)
            .padding(20)
            .zIndex(1)
            
        }
        
    }
}

#Preview {
    RegisterView()
}

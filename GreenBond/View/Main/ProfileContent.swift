//  ProfileContent.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.

import SwiftUI
import SDWebImageSwiftUI

struct ProfileContent: View {
    //var user: User
    
    @State private var loadFailed: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                VStack(spacing: 12){
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top, 30)
                    
                    /*
                    if loadFailed {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        WebImage(url: user.userProfileURL)
                            .onFailure { error in
                                loadFailed = true
                            }
                            .onSuccess { (image, data, cacheType) in
                                loadFailed = false
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }*/
                    HStack{
                        Text("Ferreira")
                            .font(.system(size: 30).bold())
                        Text("Kévin")
                            .font(.system(size: 30))
                    }
                    
                    Text("Berlin, Germany")
                        .font(.system(size: 20).bold())
                    
                    /*
                     case id
                     case userGender
                     case userCity
                     case userBirthDate
                     case userEmail
                     case userRegisterDate
                     case userDatePremium
                     case userUID
                     case userProgress
                     */
                    
                }
            }
            
        }
    }
}

#Preview {
    ProfileContent()
}


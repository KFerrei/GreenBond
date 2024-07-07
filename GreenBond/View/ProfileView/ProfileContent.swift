//  ProfileContent.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 7/7/2024.

import SwiftUI
import SDWebImageSwiftUI

struct ProfileContent: View {
    var user: User
    
    @State private var loadFailed: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                VStack(spacing: 12){
                    ZStack{

                        Circle()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                        
                        if loadFailed {
                            Image(systemName: "person")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        } else {
                            WebImage(url: user.userProfileURL)
                                .onFailure { error in
                                    loadFailed = true
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        }
                        
                    }
                    .padding(.top, 20)
                    
                    HStack{
                        Text(user.userFamilyName)
                            .font(.system(size: 40).bold())
                        Text(user.userGivenName)
                            .font(.system(size: 40))
                        if Date() < user.userDatePremium{Image(systemName: "crown.fill")}
                        if user.isAdmin{Text("A").bold()}
                    }

                    Text(user.userCity)
                        .font(.system(size: 20))
                    
                    Text("\(user.userGreenCoins) green points")
                        .font(.title)
                        .padding(10)
                        .hAlign(.center)
                    
                    BarGraphBuilder(dataPoints: user.userProgress)
                    
                    Text("my workshops")
                        .font(.system(size: 20))
                    
                }
            }
        }
    }
}

#Preview {
    MainView()
}


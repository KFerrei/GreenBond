//  ProfileContent.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.

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
                    
                    
                    HStack{
                        Text(user.userFamilyName)
                            .font(.system(size: 40).bold())
                        Text(user.userGivenName)
                            .font(.system(size: 40))
                    }
                    HStack{
                        
                        Text("@" + user.userName)
                            .font(.system(size: 20))
                        if Date() < user.userDatePremium{
                            Image(systemName: "crown.fill")
                                .foregroundColor(AppColors.greenColor)
                        }
                        
                        if user.isAdmin{
                            Text("A")
                                .bold()
                                .foregroundColor(AppColors.greenColor)
                        }
                    }
                    Text(user.userCity)
                        .font(.system(size: 20))
                    
                    HStack{
                        Text("Green Points")
                            .font(.title.bold())
                        
                        
                        Spacer()
                        
                        Text("\(user.userGreenCoins)")
                            .font(.title.bold())
                        
                    }.padding(15)
                        .hAlign(.leading)
                    
                    BarGraphBuilder(dataPoints: user.userProgress)
                    
                }
            }
        }
    }
}

#Preview {
    MainView()
}


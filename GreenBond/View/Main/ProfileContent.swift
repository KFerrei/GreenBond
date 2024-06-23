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
                            .onSuccess { (image, data, cacheType) in
                                loadFailed = false
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
                }
                Text(user.userCity)
                    .font(.system(size: 20))
                
                BarGraphBuilder(dataPoints: user.userProgress)
                
            }
        }
    }
}

#Preview {
    MainView()
}


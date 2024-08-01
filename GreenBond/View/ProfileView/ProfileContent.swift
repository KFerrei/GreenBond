//  ProfileContent.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 7/7/2024.

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ProfileContent: View {
    var user: User
    
    @State private var loadFailed: Bool = false
    @State var workshopToShow: UserWorkshop?
    
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var isFetching: Bool = false
    @AppStorage("need_fetchUser") var need_fetchUser: Bool = false
    
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
                    
                    BarGraphBuilder(dataPoints: user.userProgress, progressValue: user.userLonelinessProgress)
                    
                    Text("my workshops")
                        .font(.title)
                        .hAlign(.leading)
                        .padding(15)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            var sortedUser = user
                            ForEach(sortedUser.sortWorkshopsByDate(), id: \.workshopDateID){w in
                                MyWorkshopCardView(workshop: w, userWorkshopToShow: $workshopToShow)
                            }
                        }
                        .hAlign(.leading)
                        .padding(.horizontal, 20)
                    }
                    
                    if let workshopToShow{
                        VStack{
                            Text(workshopToShow.title)
                                .font(.headline.bold())
                                .padding(.top, 5)
                            
                            Text(Functions.dateToString(date: workshopToShow.date, form: "dd/MM/yy HH:mm"))
                                .font(.body)
                            Text(workshopToShow.adress)
                                .font(.body)
                            Text(workshopToShow.city)
                                .font(.body)
                            Text(workshopToShow.organizer)
                                .font(.body)
                            Text("\(String(workshopToShow.pricePayed)) €")
                                .font(.body)
                            
                            Button(action:deregisterWorkshop){
                                Text("deregister")
                                    .foregroundColor(.white)
                                    .fillView(Color("mainColor"))
                            }
                            .padding(10)
                        }
                        .padding(.horizontal, 20)
                        .border(2, Color("mainColor"))
                        .hAlign(.center)
                    }
                }
            }
            .padding(.bottom, 30)
        }
    }
    
    func deregisterWorkshop(){
        isLoading = true
        Task{
            do{
                try await modifyAtFirebase()
            }
            catch{
                print(error)
                await setError(error)
            }
        }
    }
    
    func modifyAtFirebase()async throws{
        do {
            let doc = Firestore.firestore().collection("WorkshopsDates").document(workshopToShow!.workshopDateID)

            try await doc.updateData([
                "userRegisterUID": FieldValue.arrayRemove([user.id!])
            ])
            
            updateUser()
        } catch {
            print(error)
        }
    }

    func updateUser(){
        do {
            let doc = Firestore.firestore().collection("Users").document(user.id!)
            var newUser = user
            newUser.userGreenCoins = newUser.userGreenCoins + workshopToShow!.gpUsed
            
            if let index = newUser.myWorkshops.firstIndex(where: { $0.workshopDateID == workshopToShow!.workshopDateID }) {
                newUser.myWorkshops.remove(at: index)
            }
            
            try doc.setData(from: newUser, completion : {error in
                if error == nil{
                    isLoading = false
                    need_fetchUser = true
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


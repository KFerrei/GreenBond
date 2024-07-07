//  ProfileView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    
    @Binding var myProfile: User?
    
    @State var showError: Bool =  false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    @State var deleteAccount: Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = true
    @AppStorage("last_fetchingUser") var last_fetchingUser: String = ""
    @AppStorage("need_fetchUser") var need_fetchUser: Bool = false
    
    var body: some View {
        VStack{
            ZStack{
                
                WaveShape(points: WaveShapePoint.points_Up2)
                    .fill(Color("mainColor"))
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .ignoresSafeArea()
                    .vAlign(.top)
                
                VStack{
                    if let myProfile, !isLoading{
                        ProfileContent(user: myProfile)
                            .refreshable {
                                self.myProfile = nil
                                await fetchUserData(forceRefresh: true)
                            }.onAppear{
                                isLoading = false
                            }
                    } else {
                        ProgressView()
                    }
                }
                
                Menu {
                    Button("log out", action: logOutUser)
                    Button("delete account", role: .destructive, action: {deleteAccount.toggle()})
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .rotationEffect(.init(degrees: 90))
                        .tint(.white)
                        .scaleEffect(1.5)
                }
                .hAlign(.trailing)
                .vAlign(.top)
                .padding(20)
            }
        }
        .fullScreenCover(isPresented: $deleteAccount){
            DeleteAccount(myProfile : $myProfile)
                .transition(.move(edge: .leading))
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
        .task({
            if myProfile != nil{return}
            await fetchUserData()
        })
    }
    
    func fetchUserData(forceRefresh: Bool = false) async {
        isLoading = true
        let last_fetch = Calendar.current.dateComponents([.day], from: Functions.stringToDate(string: last_fetchingUser, form: "dd/MM/yy") ?? Date(), to: Date())
        if !need_fetchUser, !forceRefresh, last_fetch.day! < 1, let cachedProfile = loadCachedUser() {
            myProfile = cachedProfile
        } else{
            guard let userUID = Auth.auth().currentUser?.uid else{return}
            guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else{return}
            await MainActor.run(body: {
                myProfile = user
                cacheUser(user)
                last_fetchingUser = Functions.dateToString(date: Date(), form: "dd/MM/yy")
                need_fetchUser = false
            })
        }
        isLoading = false
    }
    
    func loadCachedUser() -> User? {
        if let data = UserDefaults.standard.data(forKey: "cachedUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        }
        return nil
    }
    
    func cacheUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "cachedUser")
        }
    }
    
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
}


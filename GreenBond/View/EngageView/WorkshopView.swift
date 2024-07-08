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
    
    
    @State var workshopDateSelected : WorkshopDate?
    @State var allWorkshopDates : [WorkshopDate] = []
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var isFetching: Bool = false
    
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
                    
                    Text("Registration")
                        .font(.headline.bold())
                        .hAlign(.center)
                        .padding(.top, 15)
                    
                    Text("Select a date  :")
                        .font(.headline.bold())
                        .hAlign(.leading)
                        .padding(.top, 5)
                    
                    if isFetching{
                        ProgressView()
                    } else {
                        CalendarView(workshopDates: allWorkshopDates, workshopDateSelected : $workshopDateSelected, myProfile: $myProfile)
                    }
                    
                    if let workshopDateSelected{
                        Text("Total price :")
                            .font(.headline.bold())
                            .hAlign(.leading)
                            .padding(.top, 5)
                        LazyVGrid(columns: [GridItem(.fixed(10)), GridItem(.flexible()), GridItem(.fixed(130))], alignment: .center){
                            
                            Text("")
                            Text("\(String(workshop!.price)) €")
                                .font(.body)
                                .hAlign(.trailing)
                            Text("")
                            
                            //discount green points
                            
                            Text("-")
                                .font(.body)
                            if (myProfile!.userGreenCoins >= 50 ){
                                Text("5.00 €")
                                    .font(.body)
                                    .hAlign(.trailing)
                            } else {
                                Text("0.00 €")
                                    .font(.body)
                                    .hAlign(.trailing)
                            }
                            Text("(50 gp = 5€)")
                                .italic()
                                .font(.footnote)
                            
                            
                            
                            //discount premium if event not premium
                            if (!workshopDateSelected.forPremium){
                                
                                Text("-")
                                    .font(.body)
                                if (Date() < myProfile!.userDatePremium){
                                    Text("\(String(format: "%.2f", workshop!.price*0.1)) €")
                                        .font(.body)
                                        .hAlign(.trailing)
                                } else {
                                    Text("0.00 €")
                                        .font(.body)
                                        .hAlign(.trailing)
                                }
                                Text("(-10% for premium)")
                                    .italic()
                                    .font(.footnote)
                            }
                            Text("")
                            Divider()
                            Text("")
                            
                            Text("=")
                            
                            Text("\(String(totalPrice())) €")
                                .font(.body.bold())
                                .hAlign(.trailing)

                            
                        }
                        .frame(width: 270)
                        
                        Text("")
                        
                        
                        Button(action:registerWorkshop){
                            Text("register for this workshop")
                                .foregroundColor(.white)
                                .hAlign(.center)
                                .fillView(Color("mainColor"))
                        }
                        .disableWithOpacity(workshopDateSelected.userRegisterUID.contains(myProfile!.id!))
                        .padding(.top, 10)
                        if (workshopDateSelected.userRegisterUID.contains(myProfile!.id!)){
                            Text("Already register")
                                .italic()
                                .font(.footnote)
                                .hAlign(.center)
                        }
                    }
                    
                }
            }
            .padding(.horizontal, 20)
            .vAlign(.top)
            .alert(errorMessage, isPresented: $showError, actions: {})
            .overlay{
                LoadingView(show: $isLoading)
            }
            .refreshable {
                isFetching = true
                self.allWorkshopDates = []
                await fetchWorkshopDate()
            }
            .task{
                guard allWorkshopDates.isEmpty else{return}
                await fetchWorkshopDate()
            }
        }
    }
    
    
    func fetchWorkshopDate()async{
        do{
            let db = Firestore.firestore().collection("WorkshopsDates")
            for id in workshop!.workshopDates{
                let doc = try await db.document(id).getDocument(as: WorkshopDate.self)
                await MainActor.run {
                    allWorkshopDates.append(doc)
                }
                
            }
            allWorkshopDates.sort { $0.date < $1.date }
            isFetching = false
        }catch{
            
        }
    }
    
    func totalPrice() -> Double{
        var totalPrice = workshop!.price
        if (myProfile!.userGreenCoins >= 50 ) {
            totalPrice = totalPrice - 5.00
        }
        if (!workshopDateSelected!.forPremium && (Date() < myProfile!.userDatePremium)){
            totalPrice = totalPrice*0.9
        }
        return Double(String(format:"%.2f", totalPrice)) ?? totalPrice
    }
    
    func registerWorkshop(){
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
            let doc = Firestore.firestore().collection("WorkshopsDates").document(workshopDateSelected!.id!)
            
            try await doc.updateData([
                "userRegisterUID": FieldValue.arrayUnion([myProfile!.id!])
            ])
            
            updateUser()
        } catch {
            print(error)
        }
    }

    func updateUser(){
        do {
            let doc = Firestore.firestore().collection("Users").document(myProfile!.userUID)
            if (myProfile!.userGreenCoins >= 50 ){
                myProfile?.userGreenCoins = myProfile!.userGreenCoins - 50
            }
            
            let registerWorkshop = UserWorkshop(workshopID: workshop!.id!, workshopDateID: workshopDateSelected!.id!, title: workshop!.title, organizer: workshop!.organizer, adress: workshop!.adress, city: workshop!.city, workshopURL: workshop!.workshopURL!, date: workshopDateSelected!.date, pricePayed:  totalPrice(), gpUsed: (myProfile!.userGreenCoins >= 50 ) ? 50 : 0)
            
            myProfile!.myWorkshops.append(registerWorkshop)
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

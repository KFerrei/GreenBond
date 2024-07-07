//
//  ReusableEngageView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 6/7/2024.
//

import SwiftUI
import Firebase


struct ReusableEngageView: View {
    
    @Binding var workshops: [Workshop]
    @Binding var myProfile: User?
    @Binding var selectedTheme : String
    @Binding var openWorkshop: Bool
    @Binding var workshopToShow: Workshop?
    
    @State var isFetching: Bool = true
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                
                if isFetching{
                    ProgressView()
                }else{
                    if !workshops.isEmpty{
                        WorkshopsPosts()
                            .padding(.top, 5)
                            .padding(.bottom, 10) 
                    }
                }
            }
        }
        .onChange(of: selectedTheme){
            Task {
                self.workshops = []
                await fetchWorkshops()
            }
        }
        .refreshable {
            isFetching = true
            self.workshops = []
            await fetchWorkshops()
        }
        .task{
            guard workshops.isEmpty else{return}
            await fetchWorkshops()
        }
    }
    @ViewBuilder
    func WorkshopsPosts()->some View{
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
            ForEach(workshops){workshop in
                WorkshopCardView(workshop: workshop, openWorkshop: $openWorkshop, workshopToShow: $workshopToShow)
            }
        }.padding(.horizontal, 20)
    }


    func fetchWorkshops()async{
        if selectedTheme == "All Workshops"{
            do{
                let query = Firestore.firestore().collection("Workshops")
                let docs = try await query.getDocuments()
                let workshopsf = docs.documents.compactMap { doc in
                    try? doc.data(as: Workshop.self)
                }
                await MainActor.run(body:{
                    workshops.append(contentsOf: workshopsf)
                    isFetching = false
                })
            }catch{
                
            }
            
        } else {
            do{
                let query1 = Firestore.firestore().collection("Workshops")
                    .whereField("theme1", isEqualTo: selectedTheme)
                    .whereField("city", isEqualTo: myProfile!.userCity)
                
                let query2 = Firestore.firestore().collection("Workshops")
                    .whereField("theme2", isEqualTo: selectedTheme)
                    .whereField("city", isEqualTo: myProfile!.userCity)
                
                
                let docs1 = try await query1.getDocuments()
                let docs2 = try await query2.getDocuments()
                
                let workshops1 = docs1.documents.compactMap { doc in
                    try? doc.data(as: Workshop.self)
                }
                let workshops2 = docs2.documents.compactMap { doc in
                    try? doc.data(as: Workshop.self)
                }
                await MainActor.run(body:{
                    workshops.append(contentsOf: workshops1)
                    workshops.append(contentsOf: workshops2)
                    isFetching = false
                })
            }catch{
                print("error")
                
            }
        }
        
    }
}

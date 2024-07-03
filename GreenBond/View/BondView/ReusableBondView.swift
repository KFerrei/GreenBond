//
//  ReusableLearnPostView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 2/7/2024.
//

import SwiftUI
import Firebase

struct ReusableBondView: View {
    @Binding var learnPosts: [BondChallenges]
    @State var isFetching: Bool = true

    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                }else{
                    if learnPosts.isEmpty{
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    }else{
                        Posts()
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                    }
                }
            }
        }
        .task{
            guard learnPosts.isEmpty else{return}
            await fetchChallenges()
        }
    }
    
    @ViewBuilder
    func Posts()->some View{
        ForEach(learnPosts){post in
            BondCardView(post: post, onDelete: {
                withAnimation(.easeInOut(duration: 0.25)){
                    learnPosts.removeAll{post.id == $0.id}
                }
            })
            
        }
    }
    
    func fetchChallenges()async{
        do{
            let query = Firestore.firestore().collection("BondChallenges")
                .whereField("month", isEqualTo: Int(Calendar.current.component(.month, from: Date())))
                .order(by: "greenPoints", descending: false)
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap{ doc -> BondChallenges? in
                try? doc.data(as: BondChallenges.self)
            }
            await MainActor.run(body:{
                learnPosts.append(contentsOf: fetchedPosts)
                isFetching = false
            })
            
        }catch{
            
        }
    }
}

#Preview {
    ContentView()
}

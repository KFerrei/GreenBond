//
//  ReusableLearnPostView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 2/7/2024.
//

import SwiftUI
import Firebase

struct ReusableLearnPostView: View {
    @Binding var learnPosts: [LearnPost]
    @Binding var myProfile: User?
    
    @State var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?

    
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
        .refreshable {
            isFetching = true
            learnPosts = []
            await fetchPosts()
        }
        .task{
            guard learnPosts.isEmpty else{return}
            await fetchPosts()
        }
    }
    
    @ViewBuilder
    func Posts()->some View{
        ForEach(learnPosts){post in
            LearnPostCardView(post: post, myProfile: $myProfile){ updatedPost in
                if let index = learnPosts.firstIndex(where: {post in post.id == updatedPost.id
                }){ learnPosts[index].likedIDs = updatedPost.likedIDs
                }
            } onDelete: {
                withAnimation(.easeInOut(duration: 0.25)){
                    learnPosts.removeAll{post.id == $0.id}
                }
                
            }
            .onAppear{
                if post.id == learnPosts.last?.id && paginationDoc != nil{
                    Task{await fetchPosts()}
                }
            }

            
        }
    }
    
    func fetchPosts()async{
        do{
            var query: Query!
            if let paginationDoc{
                query = Firestore.firestore().collection("LearnPosts").order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            }else{
                query = Firestore.firestore().collection("LearnPosts").order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }

            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap{ doc -> LearnPost? in
                try? doc.data(as: LearnPost.self)
            }
            await MainActor.run(body:{
                learnPosts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            })
            
        }catch{
            
        }
    }
}

#Preview {
    ContentView()
}

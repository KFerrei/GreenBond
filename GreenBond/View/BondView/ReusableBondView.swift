//
//  ReusableLearnPostView.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 2/7/2024.
//

import SwiftUI
import Firebase

struct ReusableBondView: View {
    @Binding var bondChallenges: [BondChallenges]
    @Binding var commentChallenges: [Comment]
    @Binding var myProfile: User?
    
    @Binding var openComment: Bool
    @Binding var commentToShow: Comment?
    @Binding var challengeToShow: BondChallenges?
    @Binding var nbChallenges: Int
        
    @State var isFetching: Bool = true
    
    @AppStorage("last_fetchingChallenges") var last_fetchingChallenges: String = ""
    @AppStorage("need_fetchingComment") var need_fetchingComment: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                
                if isFetching{
                    ProgressView()
                }else{
                    if bondChallenges.isEmpty{
                        LoadingView(show: $isFetching)
                        
                        Text("No Challenge Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    }else{
                        ChallengesView()
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                    }
                }
            }
        }
        .refreshable {
            isFetching = true
            self.bondChallenges = []
            await fetchChallenges(forceRefresh: true)
            await fetchComment(forceRefresh: true)
        }
        .task{
            guard bondChallenges.isEmpty else{return}
            await fetchChallenges()
            await fetchComment()
        }
        .onChange(of: need_fetchingComment) {
            if need_fetchingComment {
                bondChallenges = []
                Task {
                    await fetchChallenges()
                    await fetchComment()
                    need_fetchingComment = false
                }
            }
        }
    }
    
    @ViewBuilder
    func ChallengesView()->some View{
        ForEach(bondChallenges){post in
            
            let comment = commentChallenges.first(where: { $0.challengeID == post.id })
            
            BondCardView(post: post, comment: comment, openComment: $openComment, commentToShow: $commentToShow, challengeToShow: $challengeToShow)
        }
        
    }
    
    func fetchChallenges(forceRefresh: Bool = false)async{
        let current_month = Calendar.current.component(.month, from: Date())
        let lastMonthFetch = Calendar.current.component(.month, from: Functions.stringToDate(string: last_fetchingChallenges, form: "dd/MM/yy") ?? Date())
        if !forceRefresh, lastMonthFetch == current_month, let cachedChallenges = loadCachedChallenges() {
            print("cache")
            bondChallenges = cachedChallenges
        } else{
            do{
                let query = Firestore.firestore().collection("BondChallenges")
                    .whereField("month", isEqualTo: Int(Calendar.current.component(.month, from: Date())))
                    .order(by: "greenPoints", descending: false)
                
                let docs = try await query.getDocuments()
                let fetchedPosts = docs.documents.compactMap{ doc -> BondChallenges? in
                    try? doc.data(as: BondChallenges.self)
                }
                await MainActor.run(body:{
                    bondChallenges.append(contentsOf: fetchedPosts)
                    isFetching = false
                    last_fetchingChallenges = Functions.dateToString(date: Date(), form: "dd/MM/yy")
                    nbChallenges = bondChallenges.count
                    cacheChallenges(bondChallenges)
                })
            }catch{
                
            }
        }
    }
    
    func fetchComment(forceRefresh: Bool = false)async{
        if !forceRefresh, !need_fetchingComment, let cachedComment = loadCachedComment() {
            print("cache")
            commentChallenges = cachedComment
        } else{
            do{
                let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))
                let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth!)
                
                let query = Firestore.firestore().collection("Comments")
                    .whereField("userID", isEqualTo: myProfile!.userUID)
                    .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startOfMonth!))
                    .whereField("date", isLessThanOrEqualTo: Timestamp(date: endOfMonth!))
                
                let docs = try await query.getDocuments()
                let fetchedPosts = docs.documents.compactMap{ doc -> Comment? in
                    try? doc.data(as: Comment.self)
                }
                await MainActor.run(body:{
                    commentChallenges.append(contentsOf: fetchedPosts)
                    isFetching = false
                    need_fetchingComment = false
                    cacheComment(commentChallenges)
                })
            }catch{
                print("error")
                
            }
        }
    }
    
    func loadCachedChallenges() -> [BondChallenges]? {
        if let data = UserDefaults.standard.data(forKey: "cachedChallenges"),
           let challenges = try? JSONDecoder().decode([BondChallenges].self, from: data) {
            return challenges
        }
        return nil
    }
    
    func cacheChallenges(_ challenges: [BondChallenges]) {
        if let encoded = try? JSONEncoder().encode(challenges) {
            UserDefaults.standard.set(encoded, forKey: "cachedChallenges")
        }
    }
    
    func loadCachedComment() -> [Comment]? {
        if let data = UserDefaults.standard.data(forKey: "cachedComment"),
           let comments = try? JSONDecoder().decode([Comment].self, from: data) {
            return comments
        }
        return nil
    }
    
    func cacheComment(_ comments: [Comment]) {
        if let encoded = try? JSONEncoder().encode(comments) {
            UserDefaults.standard.set(encoded, forKey: "cachedComment")
        }
    }
}

#Preview {
    ContentView()
}

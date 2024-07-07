//
//  CreateBond.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 3/7/2024.
//


import SwiftUI
import Firebase
import FirebaseFirestore

struct CreateBond: View {
    
    var onPost: (BondChallenges)->()
    
    @State private var postText: String = ""
    @State private var selectedPoints: Int = 1
    @State private var selectedMonth: String = "January"
    
    let numbers = Array(1...20)
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack{
            
            HStack{
                Button("Cancel", role: .destructive){
                    dismiss()
                }
                .font(.callout)
                .foregroundColor(.white)
                
                Spacer()
                
                Button(action: createPost){
                    Text ("Post")
                        .font(.callout)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(.white, in: Capsule())
                }.disableWithOpacity(postText == "")
                
                Spacer()
                
                Button("Done"){
                    showKeyboard = false
                }
                .foregroundColor(.white)
                
            }
            .hAlign(.center)
            .padding (.horizontal, 15)
            .padding(.vertical,10)
            .background{
                Rectangle()
                    .fill(Color("mainColor"))
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 15){
                
                HStack{
                    Text("challenges for month: ")
                        .foregroundColor(.gray)
                    Picker("for month", selection: $selectedMonth) {
                        ForEach(AppConstants.Lists.months, id: \.self) { month in
                            Text(month)
                        }
                    }
                    .tint(Color("mainColor"))
                    .pickerStyle(.automatic)
                    .padding()
                }
                
                HStack{
                    Text("green points: ")
                        .foregroundColor(.gray)
                    Picker("green points", selection: $selectedPoints) {
                        ForEach(numbers, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .tint(Color("mainColor"))
                    .pickerStyle(.automatic)
                    .padding()
                }
                
                
                TextField("challenges", text: $postText, axis: .vertical)
            }.padding(15)
                .focused($showKeyboard)
            
            
        }
        .vAlign(.top)
        .alert(errorMessage, isPresented: $showError, actions: {})
        .overlay{
            LoadingView(show: $isLoading)
        }
    }
    
    func createPost(){
        isLoading = true
        showKeyboard = false
        Task{
            do{
                guard let bondUID = Auth.auth().currentUser?.uid else{return}
                let indexMonth = AppConstants.Lists.months.firstIndex(of: selectedMonth)
                let post = BondChallenges(text: postText, month: indexMonth!+1, greenPoints: selectedPoints, bondUID: bondUID)
                try await createDocumentAtFirebase(post)
                
            }catch{
                await setError(error)
            }
        }
    }

    func createDocumentAtFirebase(_ post: BondChallenges)async throws{
        let doc = Firestore.firestore().collection("BondChallenges").document()
        let _ = try doc.setData(from: post, completion: {error in
            if error == nil{
                isLoading = false
                var updatedPost = post
                updatedPost.id = doc.documentID
                onPost(updatedPost)
                dismiss()
            }
        })
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

#Preview{
    CreateLearn{_ in
    }
}





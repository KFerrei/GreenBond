//
//  CreateWorkshop.swift
//  GreenBond
//
//  Created by FERREIRA Kévin on 6/7/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct CreateWorkshop: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var organizer: String = ""
    @State private var adress: String = ""
    @State private var city: String = ""
    @State private var price: Float = 0
    @State private var theme1: String = ""
    @State private var theme2: String = ""
    @State private var dates: [Date] = []
    @State private var spots: [Int] = []
    @State private var newDate: Date = Date()
    @State private var newSpot: Int = 0
    @State private var userUIDs: [[String]] = [[]]
    
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @State var workshopPicData : Data?
    @State var showImagePicker : Bool = false
    @State var photoItem: PhotosPickerItem?
    
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
                
                Button(action: createWorkshop){
                    Text ("Post")
                        .font(.callout)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(.white, in: Capsule())
                }.disableWithOpacity(isFormValid())
                
                Spacer()
                
                Button("Done"){
                    //showKeyboard = false
                }
                .foregroundColor(.white)
                
            }
            .hAlign(.center)
            .padding (.horizontal, 15)
            .padding(.vertical,10)
            .background{
                Rectangle()
                    .fill(AppColors.greenColor)
                    .ignoresSafeArea()
            }
            
            NavigationView {
                ScrollView(.vertical, showsIndicators: false){
                    VStack {
                        GeometryReader { geometry in
                            Rectangle()
                                .frame(width: geometry.size.width + 5, height: 205)
                                .foregroundColor(.white)
                            ZStack{
                                if let workshopPicData, let image = UIImage(data: workshopPicData){
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }else{
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(AppColors.greenColor)
                                }
                            }
                            .frame(width: geometry.size.width, height: 200)
                            .clipShape(Rectangle())
                            .contentShape(Rectangle())
                            .cornerRadius(10)
                            .onTapGesture {
                                showImagePicker.toggle()
                            }
                        }.frame(height: 215)
                        
                        
                        Text("title")
                            .italic()
                            .hAlign(.leading)
                        TextField("", text: $title)
                            .border(1, .gray.opacity(0.5))
                        
                        Text("description")
                            .italic()
                            .hAlign(.leading)
                        TextEditor(text: $description)
                            .frame(minHeight: 100) // Set minimum height
                            .border(1, .gray.opacity(0.5))
                        
                        Text("organizer")
                            .italic()
                            .hAlign(.leading)
                        TextField("", text: $organizer)
                            .border(1, .gray.opacity(0.5))
                        
                        Text("adress")
                            .italic()
                            .hAlign(.leading)
                        TextField("Adress", text: $adress)
                            .border(1, .gray.opacity(0.5))
                        
                        HStack{
                            Text("city")
                                .italic()
                                .hAlign(.leading)
                            
                            Picker("city", selection: $city){
                                ForEach(AppConstants.Lists.cities, id: \.self) {
                                    Text($0)
                                }
                            }
                            .tint(.black)
                            .textContentType(.addressCityAndState)
                            
                        }
                        
                        HStack{
                            Text("price")
                                .italic()
                                .hAlign(.leading)
                            HStack{
                                TextField("", text: Binding(
                                    get: { String(format: "%.2f", self.price) },
                                    set: { if let value = Float($0) { self.price = value } }
                                )).keyboardType(.decimalPad)
                                    .border(1, .gray.opacity(0.5))
                                Text("€")
                            }
                        }
                        Text("themes")
                            .italic()
                            .hAlign(.leading)
                        
                        Picker("", selection: $theme1){
                            ForEach(AppConstants.Lists.themes, id: \.self) {
                                Text($0)
                            }
                        }
                        .tint(.black)
                        .textContentType(.addressCityAndState)
                        
                        Picker("", selection: $theme2){
                            ForEach(AppConstants.Lists.themes, id: \.self) {
                                Text($0)
                            }
                        }
                        .tint(.black)
                        .textContentType(.addressCityAndState)
                        
                        VStack{
                            HStack{
                                Text("dates")
                                    .italic()
                                    .hAlign(.leading)
                                Text("spots")
                                    .italic()
                                    .hAlign(.leading)
                                    .padding(.leading, 15)
                            }
                            
                            HStack{
                                DatePicker("", selection: $newDate, displayedComponents: [.date, .hourAndMinute])
                                    .frame(height: 50)
                                
                                TextField("", text: Binding(
                                    get: { String(format: "%", self.newSpot) },
                                    set: { if let value = Int($0) { self.newSpot = value } }
                                )).keyboardType(.decimalPad)
                                    .border(1, .gray.opacity(0.5))
                                    .frame(height: 50)
                                
                                Button(action: {addNewEntry()}){
                                    Text("+")
                                        .font(.system(size: 30).bold())
                                        .foregroundColor(AppColors.greenColor)
                                        .frame(height: 50)
                                }
                                
                            }
                            
                            HStack(spacing: 20){
                                VStack{
                                    ForEach(spots.indices, id: \.self) { i in
                                        Button(action: {removeEntry(index: i)}){
                                            Text("-")
                                                .font(.system(size: 30).bold())
                                                .foregroundColor(.red)
                                        }.frame(width: 30, height: 30)
                                    }
                                }
                                
                                VStack{
                                    ForEach(dates, id: \.self) { date in
                                        Text(Functions.dateHoursToString(date: date))
                                            .hAlign(.leading)
                                            .frame(height: 30)
                                    }
                                }
                                
                                VStack{
                                    ForEach(spots, id: \.self) { spot in
                                        Text("\(spot)")
                                            .hAlign(.leading)
                                            .frame(height: 30)
                                    }
                                }
                                
                            }.padding(.leading, 15)
                            
                        }.vAlign(.top)
                    }
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .onChange(of: photoItem){
                if let photoItem{
                    Task{
                        if let rawImageData = try await photoItem.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5){
                            await MainActor.run(body: {
                                workshopPicData = compressedImageData
                            })
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
        }
        .onAppear {
            city = AppConstants.Lists.cities[0]
            theme1 = AppConstants.Lists.themes[0]
            theme2 = AppConstants.Lists.themes[0]
        }
    }
    
    func addNewEntry() {
        dates.insert(newDate, at: 0)
        spots.insert(newSpot, at: 0)
        userUIDs.insert([], at: 0)
        newSpot = 0
    }
    
    func removeEntry(index: Int) {
        dates.remove(at: index)
        spots.remove(at: index)
        userUIDs.remove(at: index)
    }
    
    func isFormValid() -> Bool {
        return title.isEmpty ||
        description.isEmpty ||
        organizer.isEmpty ||
        adress.isEmpty ||
        city.isEmpty ||
        price != 0 ||
        theme1.isEmpty ||
        city.isEmpty ||
        workshopPicData == nil
    }
    
    func createWorkshop(){
        isLoading = true
        showKeyboard = false
        Task{
            do{
                let imageReferenceID = UUID().uuidString
                let storageRef = Storage.storage().reference().child("WorkshopImages").child(imageReferenceID)
                let _ = try await storageRef.putDataAsync(workshopPicData!)
                let dowloadURL = try await storageRef.downloadURL()
                    
                let workshop = Workshop(title: title, description: description, organizer: organizer, adress: adress, city: city, price: price, theme1: theme1, theme2: theme2, dates: dates, spots: spots, userUIDs: userUIDs, workshopURL: dowloadURL, workshopImageID: imageReferenceID)
                
                try await createDocumentAtFirebase(workshop)

            }catch{
                print(error)
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ workshop: Workshop)async throws{
        let doc = Firestore.firestore().collection("Workshop").document()
        let _ = try doc.setData(from: workshop, completion: {error in
            if error == nil{
                var updatedWorkshop = workshop
                updatedWorkshop.id = doc.documentID
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




#Preview {
    CreateWorkshop()
}

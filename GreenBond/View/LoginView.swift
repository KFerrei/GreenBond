//  ContentView.swift
//  GreenBond
//  Created by FERREIRA Kévin on 20/6/2024.
//  Modified by FERREIRA Kévin on 21/6/2024.

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var emailID : String = ""
    @State var password: String = ""
    
    @State var createAccount: Bool = false
    @State var showError: Bool =  false
    @State var errorMessage: String = ""

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "105b37"))
                .frame(width: 300, height: 300)
                .offset(x: 150, y: -400)
                .zIndex(0)
            
            Circle()
                .fill(Color(hex: "105b37"))
                .frame(width: 400, height: 400)
                .offset(x: -20, y: 300)
                .zIndex(0)
            
            VStack(spacing: 10){
                Text("green bond")
                    .font(.system(size: 50).bold())
                    .hAlign(.center)
                
                VStack(spacing: 10){
                    TextField("email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                        .padding(.top,25)
                    
                    SecureField("password", text: $password)
                        .textContentType(.password)
                        .border(1, .gray.opacity(0.5))
                    
                    Button(action: loginUser){
                        Text("sign in")
                            .foregroundColor(.white)
                            .hAlign(.center)
                            .fillView(.black)
                    }.padding(.top, 10)
                    
                    Button("reset password?", action: resetPassword)
                        .font(.callout)
                        .fontWeight(.medium)
                        .tint(.black)
                        .hAlign(.trailing)
                    
                }
                
                HStack{
                    Text("don't have an account yet?")
                    
                    Button("register now"){
                        createAccount.toggle()
                        
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    
                }
                .hAlign(.center)
                .vAlign(.bottom)
                
            }
            .vAlign(.center)
            .padding(20)
            .padding(.top, 100)
            .zIndex(1)
            
        }                
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
                .transition(.move(edge: .leading))
        }
        .alert(errorMessage, isPresented: $showError, actions: {})

    }
    
    func loginUser(){
        Task{
            do{
                try await Auth.auth().signIn(withEmail: emailID, password: password)
            }catch{
                await setError(error)
            }
        }
    }
    
    func resetPassword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
            }catch{
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

#Preview {
    LoginView()
}

// MARK: View Extensions for UI Building
extension View{
    
    func disableWithOpacity(_ condition: Bool)->some View{
        self.disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    func hAlign(_ alignment: Alignment)->some View{
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment)->some View{
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func border(_ width: CGFloat, _ color: Color)->some View{
        self.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background{
                RoundedRectangle(cornerRadius: 5, style:.continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    func fillView(_ color: Color)->some View{
        self.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background{
                RoundedRectangle(cornerRadius: 5, style:.continuous)
                    .fill(color)
            }
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
      
}

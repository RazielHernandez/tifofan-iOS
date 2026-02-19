//
//  SignUp.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-19.
//

import SwiftUI

struct SignUp: View {
    var body: some View {
        
        @State var email: String = ""
        @State var confirmEmail: String = ""
        @State var password: String = ""
        @State var confirmPassword: String = ""
        
        VStack {
            
            
            Image("TifoFan")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                .shadow(radius: 10)
                .padding()
            
            Spacer()
            
            Text("eMail")
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Confirm email")
            TextField("Confirm Email", text: $confirmEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Password")
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Confirm password")
            TextField("Confirm password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Spacer()
            
        }
    }
}


#Preview {
    SignUp()
}

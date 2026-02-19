//
//  Sig.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-19.
//

import SwiftUI

struct SignIn: View {
    var body: some View {
        
        
        @State var email: String = ""
        @State var password: String = ""
        
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
            
            Text("Password")
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Spacer()
            
        }
        
    }
}

#Preview {
    SignIn()
}

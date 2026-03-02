//
//  ErrorScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-27.
//

import SwiftUI

struct ErrorScreen: View {
    
    var errorMessage: String
    var errorCode: String?
    var errorCodeDescription: String?
    
    var body: some View {
        VStack {
            Text("Offside !")
                .font(.largeTitle)
                .bold()
            
            Image("DeflateredSoccerBall")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .padding()
            
            Text("Something went wrong")
                .font(.title)
            
            if ((errorCode) != nil) {
                Text("Error code: \(errorCode ?? "0000")")
            }
            
            if ((errorCodeDescription) != nil) {
                Text("\(errorCodeDescription ?? "Unknown")")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.accentColor)
    }
}


#Preview {
    ErrorScreen(errorMessage: "Something went wrong", errorCode: "204", errorCodeDescription: "No connection")
}

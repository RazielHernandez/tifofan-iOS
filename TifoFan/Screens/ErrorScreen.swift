//
//  ErrorScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-27.
//

import SwiftUI

struct ErrorScreen: View {
    
    var errorMessage: String
    
    var body: some View {
        VStack {
            Text("Ooops !!")
                .font(.largeTitle)
                .bold()
            
            Image("DeflateredSoccerBall")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .padding()
            
            Text("Something went wrong")
                .font(.title)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.accentColor)
    }
}


#Preview {
    ErrorScreen(errorMessage: "Something went wrong")
}

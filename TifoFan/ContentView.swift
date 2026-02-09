//
//  ContentView.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            
            Tab("Dashboard", systemImage: "house") {
                
            }
            
            
            Tab("My Club", systemImage: "soccerball") {
                
            }
            
            Tab("Statistics", systemImage: "chart.bar") {
                
            }
            
            Tab("Settings", systemImage: "gearshape") {
                
            }
        }
    }
}

#Preview {
    ContentView()
}

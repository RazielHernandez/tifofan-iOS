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
                DashboardScreen()
            }
            
            
            Tab("My Club", systemImage: "soccerball") {
                MyClubScreen()
            }
            
            Tab("Statistics", systemImage: "chart.bar") {
                StatisticsScreen()
            }
            
            Tab("Settings", systemImage: "gearshape") {
                SettingsScreen()
            }
        }
    }
}

#Preview {
    ContentView()
}

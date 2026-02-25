//
//  _LeaguesScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import SwiftUI

struct LeaguesScreen: View {
    @StateObject private var viewModel = LeagueViewModel()
        
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    VStack(alignment: .center) {
                        Image(systemName: "wifi.slash")
                            .resizable()
                            .frame(width: 128, height: 128, alignment: .center)
                            .padding()
                        
                        Text(error)
                            .font(Font.title3.bold())
                            
                    }
                    
                } else {
                    List(viewModel.leagues) { league in
                        Text(league.name)
                    }
                }
            }
            .navigationTitle("Leagues")
        }
        .task {
            await viewModel.fetchLeagues()
        }
    }
}

#Preview {
    LeaguesScreen()
}

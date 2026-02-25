//
//  _MatchesScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import SwiftUI

struct MatchesScreen: View {
    @StateObject private var viewModel = MatchViewModel()
        
    // Change these values depending on your test league
    private let leagueId = 262
    private let season = 2023
    
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
                    List(viewModel.matches) { match in
                        Text("\(match.home.team.name) vs \(match.away.team.name)")
                    }
                }
            }
            .navigationTitle("Matches")
        }
        .task {
            await viewModel.fetchMatches(leagueId: leagueId, season: season)
        }
    }
}


#Preview {
    MatchesScreen()
}

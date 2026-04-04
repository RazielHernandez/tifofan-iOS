//
//  Untitled.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

struct TeamsView: View {
    
    let league: League
    
    @StateObject private var vm = LeagueViewModel()
    
    private let season = 2025
    
    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView()
            } else if let error = vm.errorMessage {
                Text(error)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.teams) { team in
                            TeamRow(team: team)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await vm.fetchLeaguesWithTeams(
                league: league.id,
                season: season
            )
        }
    }
}

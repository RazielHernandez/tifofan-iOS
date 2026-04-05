//
//  Untitled.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

struct TeamsView: View {
    
    let league: League
    @ObservedObject var vm: LeagueViewModel
    
    private let season = 2024
    
    var body: some View {
        NavigationView{
            if vm.isLoading {
                ProgressView()
            } else if let error = vm.errorMessage {
                Text(error)
            } else {
                Group {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            
                            ForEach(vm.teams, id: \.id) { team in
                                
                                NavigationLink {
                                    TeamDetailScreen(
                                        teamId: team.id,
                                        leagueId: league.id,
                                        season: 2025
                                    )
                                } label: {
                                    TeamRow(team: team)
                                }
                            }
                        }
                        .padding()
                    }
                }
                
            }
        }
        
        .task {
            if vm.teams.isEmpty {
                await vm.fetchLeaguesWithTeams(
                    league: league.id,
                    season: season
                )
            }
        }
    }
}

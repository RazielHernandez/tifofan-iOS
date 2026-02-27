//
//  _TeamDetailsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import SwiftUI

struct TeamDetailScreen: View {
    
    let teamId: Int
    let leagueId: Int
    let season: Int
    
    @StateObject private var vm = TeamDetailsViewModel()
    
    var body: some View {
        ScrollView {
            
            if vm.isLoading {
                ProgressView()
                    .padding()
            }
            
            if let response = vm.response {
                
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    VStack(spacing: 12) {
                        
                        if let logo = response.team.logo,
                           let url = URL(string: logo) {
                            
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                        }
                        
                        Text(response.team.name)
                            .font(.title)
                            .bold()
                    }
                    
                    // MARK: - Aggregates
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Season Overview")
                            .font(.headline)
                        
                        aggregateRow("Played", response.aggregates.matchesPlayed)
                        aggregateRow("Wins", response.aggregates.wins)
                        aggregateRow("Draws", response.aggregates.draws)
                        aggregateRow("Losses", response.aggregates.losses)
                        aggregateRow("Goals For", response.aggregates.goalsFor)
                        aggregateRow("Goals Against", response.aggregates.goalsAgainst)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // MARK: - League Stats
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("League Stats")
                            .font(.headline)
                        
                        let stats = response.stats

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Form: \(stats.form)")
                            
                            Text("Played: \(stats.fixtures.played)")
                            Text("W: \(stats.fixtures.wins)")
                            Text("D: \(stats.fixtures.draws)")
                            Text("L: \(stats.fixtures.losses)")
                            
                            Text("Goals For: \(stats.goals.for)")
                            Text("Goals Against: \(stats.goals.against)")
                        }
                    }
                }
                .padding()
            }
            
            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Team Details")
        .task {
            await vm.fetchTeamDetails(
                teamId: teamId,
                leagueId: leagueId,
                season: season
            )
        }
    }
    
    private func aggregateRow(_ title: String, _ value: Int) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value)")
                .bold()
        }
    }
}

#Preview {
    TeamDetailScreen(teamId: 2286, leagueId: 262, season: 2023)
}

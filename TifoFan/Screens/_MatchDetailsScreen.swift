//
//  _MatchDetailsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-25.
//

import SwiftUI

struct MatchDetailScreen: View {
    
    @StateObject private var viewModel = MatchViewModel()
        
    // Test values
    private let matchId = 1031276
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            }
            else if let error = viewModel.errorMessage {
                ErrorScreen(errorMessage: "Ooops! we were unable to get the data. Please try again later.")
            }
            else if let match = viewModel.selectedMatch {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        Text("Match Details")
                            .font(.largeTitle)
                            .bold()
                        
                        // MARK: Score Section
                        VStack(spacing: 16) {
                            
                            Text(match.status)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack {
                                
                                // HOME
                                VStack(spacing: 8) {
                                    AsyncImage(url: URL(string: match.home.team.logo)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 60, height: 60)
                                    
                                    Text(match.home.team.name)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("\(match.home.goals)")
                                        .font(.largeTitle.bold())
                                }
                                
                                Spacer()
                                
                                Text("-")
                                    .font(.largeTitle.bold())
                                
                                Spacer()
                                
                                // AWAY
                                VStack(spacing: 8) {
                                    AsyncImage(url: URL(string: match.away.team.logo)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 60, height: 60)
                                    
                                    Text(match.away.team.name)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("\(match.away.goals)")
                                        .font(.largeTitle.bold())
                                }
                            }
                        }
                        
                        Divider()
                        
                        // MARK: Match Info
                        VStack(alignment: .leading, spacing: 12) {
                            
                            InfoRow(
                                title: "Date",
                                value: match.date.formatted(date: .abbreviated, time: .shortened)
                            )
                            
                            InfoRow(
                                title: "League ID",
                                value: "\(match.leagueId)"
                            )
                            
                            InfoRow(
                                title: "Season",
                                value: "\(match.season)"
                            )
                        }
                    }
                    .padding()
                }
            }
            else {
                Text("Nothing to show.")
            }
        }
        .navigationTitle("Match Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMatchDetail(matchId: matchId)
        }
    }
}

// MARK: InfoRow
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    MatchDetailScreen()
}

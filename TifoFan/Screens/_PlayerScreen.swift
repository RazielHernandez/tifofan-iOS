//
//  _PlayerScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-25.
//

import SwiftUI

struct PlayerScreen: View {
    
    let playerId: Int = 35960
    let season: Int = 2023
    
    @StateObject private var viewModel = PlayerViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            }
            else if let error = viewModel.errorMessage {
                VStack {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 60))
                        .padding()
                    
                    Text(error)
                        .multilineTextAlignment(.center)
                }
            }
            else if let data = viewModel.response {
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: Player Header
                        VStack(spacing: 12) {
                            
                            AsyncImage(url: URL(string: data.player.photo)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                            Text(data.player.name)
                                .font(.title.bold())
                            
                            Text("\(data.player.age) • \(data.player.nationality)")
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                        
                        // MARK: Aggregates Card
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Season Totals")
                                .font(.headline)
                            
                            InfoRow(title: "Appearances", value: "\(data.aggregates.appearances)")
                            InfoRow(title: "Minutes", value: "\(data.aggregates.minutes)")
                            InfoRow(title: "Goals", value: "\(data.aggregates.goals)")
                            InfoRow(title: "Assists", value: "\(data.aggregates.assists)")
                            InfoRow(title: "Yellow Cards", value: "\(data.aggregates.yellowCards)")
                            InfoRow(title: "Red Cards", value: "\(data.aggregates.redCards)")
                            
                            if let rating = data.aggregates.averageRating {
                                InfoRow(title: "Avg Rating", value: String(format: "%.1f", rating))
                            }
                        }
                        
                        Divider()
                        
                        // MARK: Per Competition Stats
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Competitions")
                                .font(.headline)
                            
                            ForEach(data.stats) { stat in
                                CompetitionRow(stat: stat)
                            }
                        }
                    }
                    .padding()
                }
            }
            else {
                Text("Nothing to show here. Try refreshing.")
            }
        }
        .navigationTitle("Player")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchPlayer(playerId: playerId, season: season)
        }
    }
}

// MARK: Competition Row
struct CompetitionRow: View {
    
    let stat: PlayerSeasonStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            HStack {
                AsyncImage(url: URL(string: stat.team.logo)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 30, height: 30)
                
                VStack(alignment: .leading) {
                    Text(stat.leagueName)
                        .font(.subheadline.bold())
                    
                    Text(stat.position)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Text("Apps: \(stat.appearances)")
                Spacer()
                Text("Goals: \(stat.goals)")
                Spacer()
                Text("Assists: \(stat.assists)")
            }
            .font(.caption)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: Preview
#Preview {
    PlayerScreen()
}

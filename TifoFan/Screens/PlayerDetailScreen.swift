//
//  PlayerDetailScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-05.
//

import SwiftUI

struct PlayerDetailScreen: View {
    
    let playerId: Int
    
    @StateObject private var vm = PlayerViewModel()
    
    var body: some View {
        ScrollView {
            
            if vm.isLoading {
                ProgressView()
            } else if let data = vm.data {
                
                VStack(spacing: 16) {
                    
                    // 🧑 HEADER
                    VStack(spacing: 8) {
                        
                        AsyncImage(url: data.player.photo) { image in
                            image.resizable()
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.2))
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        
                        Text(data.player.name)
                            .font(.title2)
                            .bold()
                        
                        Text(data.player.nationality)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    // 📊 AGGREGATE STATS
                    PlayerStatsGrid(stats: data.aggregates)
                    
                    Divider()
                    
                    // 📅 SEASON STATS
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Season Stats")
                            .font(.headline)
                        
                        ForEach(data.stats) { stat in
                            PlayerSeasonRow(stat: stat)
                        }
                    }
                }
                .padding()
                
            } else if let error = vm.errorMessage {
                Text(error)
            }
        }
        .navigationTitle("Player")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchPlayer(playerId: playerId, season: 2025)
        }
    }
}

struct PlayerStatsGrid: View {
    
    let stats: PlayerAggregates
    
    var body: some View {
        VStack(spacing: 12) {
            
            HStack {
                StatItem(title: "Goals", value: "\(stats.goals)")
                StatItem(title: "Assists", value: "\(stats.assists)")
                StatItem(title: "Apps", value: "\(stats.appearances)")
            }
            
            HStack {
                StatItem(title: "Minutes", value: "\(stats.minutes)")
                StatItem(title: "Yellow", value: "\(stats.yellowCards)")
                StatItem(title: "Red", value: "\(stats.redCards)")
            }
            
            if let rating = stats.averageRating {
                StatItem(title: "Rating", value: String(format: "%.1f", rating))
            }
        }
    }
}

struct PlayerSeasonRow: View {
    
    let stat: PlayerSeasonStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            HStack {
                Text(stat.team.name)
                Spacer()
                Text(stat.leagueName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text("G: \(stat.goals)")
                Text("A: \(stat.assists)")
                Text("Apps: \(stat.appearances)")
                Spacer()
            }
            .font(.caption)
        }
        .padding(.vertical, 6)
    }
}

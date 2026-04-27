//
//  DashboardTeamScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-25.
//

import SwiftUI

struct TeamDashboardCard: View {
    
    let team: TeamSummary
    let season: Int
    @ObservedObject var matchesVM: MatchViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var tifoVM: TifoViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                TeamHeader(team: team)
                
                NavigationLink {
                    TifoGeneratorScreen(team: team)
                } label: {
                    TifoCard(grid: tifoVM.tifosByTeam[team.id])
                }
                .buttonStyle(.plain)
                
                if let match = matchesVM.nextMatch(forTeam: team.id) {
                    MatchHighlightCard(match: match)
                } else {
                    Text("No upcoming matches")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                TeamStatsPreview(teamId: team.id)
            }
            .padding()
        }
        .task {
            await matchesVM.fetchMatchesByTeam(
                teamId: team.id,
                season: season
            )
        }
    }
}

struct TeamHeader: View {
    
    let team: TeamSummary
    
    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: team.logo) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(team.name)
                    .font(.headline)
                
                Text("Team")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct TeamStatsPreview: View {
    
    let teamId: Int
    
    @StateObject private var vm = TeamDetailsViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Team Stats")
                .font(.headline)
            
            if vm.isLoading {
                ProgressView()
                
            } else if let stats = vm.teamDetail {
                
                HStack(spacing: 12) {
                    
                    statCard(title: "Played", value: 10)
                    statCard(title: "Wins", value: 6)
                    statCard(title: "Goals", value: 4)
                    //statCard(title: "Played", value: stats.played)
                    //statCard(title: "Wins", value: stats.wins)
                    //statCard(title: "Goals", value: stats.goals)
                }
                
            } else {
                Text("No stats available")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        .task {
            //await vm.fetchStats(teamId: teamId)
        }
    }
    
    private func statCard(title: String, value: Int) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("\(value)")
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
}

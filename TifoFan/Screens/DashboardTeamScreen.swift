//
//  DashboardTeamScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-25.
//

import SwiftUI

struct TeamDashboardCard: View {
    
    let team: TeamSummary
    
    @ObservedObject var matchesVM: MatchViewModel
    @EnvironmentObject var tifoVM: TifoViewModel
    
    var body: some View {
        
        let tifo = tifoVM.tifosByTeam[team.id]
        let baseColor = tifo?.dominantColor ?? Color.blue
        
        
        ZStack {
            baseColor.opacity(0.12).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    TeamHeader(team: team)
                    
                    // 🎨 TIFO
                    NavigationLink {
                        TifoGeneratorScreen(team: team)
                    } label: {
                        TifoCard(grid: tifo)
                    }
                    .buttonStyle(.plain)
                    
                    // ⚽ NEXT MATCH
                    if let match = matchesVM.nextMatch(forTeam: team.id) {
                        NextMatchCard(match: match)
                    }
                    
                    // 📊 STATS
                    TeamStatsPreview(team: team)
                    
                }
                .padding()
            }
            .background(
                baseColor
                    .opacity(0.2)
                    .ignoresSafeArea()
            )
            .task {
                await matchesVM.fetchMatchesByTeam(
                    teamId: team.id,
                    season: team.season
                )
            }
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
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct NextMatchCard: View {
    
    let match: Match
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Label("Next Match", systemImage: "calendar")
                .font(.headline)
            
            HStack {
                
                AsyncImage(url: match.home.team.logo) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 32, height: 32)
                
                Text(match.home.team.name)
                    .font(.subheadline)
                
                Spacer()
                
                Text("vs")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(match.away.team.name)
                    .font(.subheadline)
                
                AsyncImage(url: match.away.team.logo) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 32, height: 32)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Label(match.venue.name, systemImage: "mappin")
                Label(formatDate(match.date), systemImage: "clock")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
    
    func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }
}

struct TeamStatsPreview: View {
    
    let team: TeamSummary
    @EnvironmentObject var statsVM: TeamStatsViewModel
    
    var body: some View {
        
        let stats = statsVM.statsByTeam[team.id]
        
        VStack(alignment: .leading, spacing: 12) {
            
            Label("Team Stats", systemImage: "chart.bar")
                .font(.headline)
            
            if statsVM.isLoading && stats == nil {
                ProgressView()
                
            } else if let stats {
                
                // 🔥 FORM
                FormView(form: stats.stats.form)
                
                HStack {
                    statCard("Played", stats.aggregates.matchesPlayed)
                    statCard("Wins", stats.aggregates.wins)
                    statCard("Goals", stats.aggregates.goalsFor)
                }
                
            } else {
                Text("No stats available")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .task {
            await statsVM.fetch(
                teamId: team.id,
                leagueId: team.leagueId,
                season: team.season
            )
        }
    }
    
    private func statCard(_ title: String, _ value: Int) -> some View {
        VStack {
            Text("\(value)")
                .font(.headline.bold())
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FormView: View {
    
    let form: String
    
    var body: some View {
        HStack(spacing: 6) {
//            ForEach(Array(form.suffix(5)), id: \.self) { result in
//                Text(String(result))
//                    .font(.caption.bold())
//                    .frame(width: 28, height: 28)
//                    .background(color(for: result))
//                    .foregroundColor(.white)
//                    .clipShape(Circle())
//            }
            ForEach(Array(form.suffix(5).enumerated()), id: \.offset) { index, result in
                Text(String(result))
                    .frame(width: 28, height: 28)
                    .background(color(for: result))
                    .clipShape(Circle())
            }
        }
    }
    
    func color(for result: Character) -> Color {
        switch result {
        case "W": return .green
        case "D": return .orange
        case "L": return .red
        default: return .gray
        }
    }
}

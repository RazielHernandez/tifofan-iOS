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
        let primary = tifo?.dominantColor ?? .blue
        let secondary = tifo?.secondaryColor ?? primary.opacity(0.6)

        ZStack {

            

            // 🧩 CARD
            ScrollView {
                VStack(spacing: 16) {

                    TeamHeader(team: team)

                    NavigationLink {
                        TifoGeneratorScreen(team: team)
                    } label: {
                        TifoCard(grid: tifo)
                    }
                    .buttonStyle(.plain)

                    NextMatchSection(
                        match: matchesVM.nextMatches[team.id],
                        isLoading: matchesVM.matchesByTeam[team.id] == nil
                    )

                    TeamStatsPreview(team: team)
                }
                .padding()
            }
            //.background(.ultraThinMaterial) // 👈 card surface
            .background(
    
                LinearGradient(
                    colors: [
                        primary.opacity(0.55),
                        secondary.opacity(0.55),
                        primary.opacity(0.25),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .clipShape(RoundedRectangle(cornerRadius: 24)) // 👈 THIS is key
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .task(id: team.id) {
            if matchesVM.matchesByTeam[team.id] == nil {
                await matchesVM.fetchMatchesByTeam(
                    teamId: team.id,
                    season: team.season
                )
            }
        }
    }
    
//    var body: some View {
//        
//        let tifo = tifoVM.tifosByTeam[team.id]
//        let primary = tifo?.dominantColor ?? .blue
//        let secondary = tifo?.secondaryColor ?? primary.opacity(0.6)
//
//        ScrollView {
//            VStack(spacing: 16) {
//                
//                TeamHeader(team: team)
//                
//                NavigationLink {
//                    TifoGeneratorScreen(team: team)
//                } label: {
//                    TifoCard(grid: tifo)
//                }
//                .buttonStyle(.plain)
//                
//                NextMatchSection(
//                    match: matchesVM.nextMatches[team.id],
//                    isLoading: matchesVM.matchesByTeam[team.id] == nil
//                )
//                
//                TeamStatsPreview(team: team)
//            }
//            .padding()
//        }
//        .background(
//            
//            LinearGradient(
//                colors: [
//                    primary.opacity(0.55),
//                    secondary.opacity(0.55),
//                    primary.opacity(0.25),
//                    Color.clear
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//        )
//        .padding()
//        .cornerRadius(16)
//        .task(id: team.id) {
//            if matchesVM.matchesByTeam[team.id] == nil {
//                await matchesVM.fetchMatchesByTeam(
//                    teamId: team.id,
//                    season: team.season
//                )
//            }
//        }
//    }
}

struct NextMatchSection: View {
    
    let match: Match?
    let isLoading: Bool
    
    var body: some View {
        VStack {
            if isLoading {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Label("Next Match", systemImage: "calendar")
                        .font(.headline)
                    
                    HStack {
                        
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                
                
            } else if let match {
                NextMatchCard(match: match)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else {
                Text("No upcoming match")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
        }
        .animation(.easeInOut, value: match?.id)
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
        
        VStack(alignment: .leading, spacing: 16) {
            
            Label("Team Stats", systemImage: "chart.bar")
                .font(.headline)
            
            if statsVM.isLoading && stats == nil {
                ProgressView()
                    .frame(maxWidth: .infinity)
                
            } else if let stats {
                
                // 🔥 FORM
                FormView(form: stats.stats.form)
                
                // ➖ DIVIDER (subtle)
                Divider()
                    .opacity(0.6)
                
                // 📊 AGGREGATES
                VStack(alignment: .leading, spacing: 10) {
                    
                    Label("Season Overview", systemImage: "chart.xyaxis.line")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 12) {
                        statCard("Played", stats.aggregates.matchesPlayed)
                        statCard("Wins", stats.aggregates.wins)
                        statCard("Goals", stats.aggregates.goalsFor)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                
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
        VStack(spacing: 6) {
            Text("\(value)")
                .font(.headline.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

struct FormView: View {
    
    let form: String
    @State private var animate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // 🔥 TITLE + LEGEND
            HStack {
                Label("Recent Form", systemImage: "waveform.path.ecg")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                legend
            }
            
            // 🎯 LAST 5 MATCHES
            HStack(spacing: 8) {
                ForEach(Array(form.suffix(5).enumerated()), id: \.offset) { index, result in
                    Text(String(result))
                        .font(.caption.bold())
                        .frame(width: 28, height: 28)
                        .background(color(for: result))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .scaleEffect(animate ? 1 : 0.6)
                        .opacity(animate ? 1 : 0)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.7)
                            .delay(Double(index) * 0.05),
                            value: animate
                        )
                }
            }
        }
        .onAppear {
            animate = true
        }
    }
    
    // 🎨 LEGEND
    private var legend: some View {
        HStack(spacing: 6) {
            legendItem("W", .green)
            legendItem("D", .orange)
            legendItem("L", .red)
        }
        .font(.caption2)
    }
    
    private func legendItem(_ text: String, _ color: Color) -> some View {
        HStack(spacing: 2) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(text)
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

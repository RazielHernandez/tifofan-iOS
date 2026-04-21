//
//  StandingsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-05.
//

import SwiftUI

enum StandingMode: String, CaseIterable {
    case all = "All"
    case home = "Home"
    case away = "Away"
    case stats = "Stats"
}

struct StandingsScreen: View {
    
    let leagueId: Int
    let season: Int
    
    @ObservedObject var vm: StandingsViewModel
    
    @State private var mode: StandingMode = .all
    
    var body: some View {
        VStack {
            
            // 🔥 Tabs
            HStack {
                ForEach(StandingMode.allCases, id: \.self) { m in
                    Button {
                        mode = m
                    } label: {
                        Text(m.rawValue)
                            .font(.subheadline)
                            .foregroundColor(mode == m ? .white : .blue)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(mode == m ? Color.blue : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            if vm.isLoading {
                Spacer()
                ProgressView()
                Spacer()
                
            } else if let error = vm.errorMessage {
                
                ErrorScreen(errorMessage: error)
            } else {
                
                if mode == .stats {
                    LeagueStatsView(
                        leagueId: leagueId,
                        season: season
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            
                            StandingsHeader()
                            
                            ForEach(vm.standings) { row in
                                StandingsRowView(
                                    row: row,
                                    mode: mode,
                                    leagueId: leagueId,
                                    season: season
                                )
                                Divider()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Standings")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchStandings(league: leagueId, season: season)
        }
        .onChange(of: season) {
            Task {
                await vm.fetchStandings(league: leagueId, season: season)
            }
        }
    }
}

struct LeagueStatsView: View {
    
    let leagueId: Int
    let season: Int
    
    @StateObject private var vm = LeagueStatsViewModel()
    
    var body: some View {
        ScrollView {
            if vm.isLoading {
                ProgressView()
                    .padding()
                
            } else if let stats = vm.stats {
                
                VStack(spacing: 20) {
                    
                    playerSection(
                        title: "Top Scorers",
                        players: stats.topScorers,
                        statValue: { $0.statistics.goals },
                        badge: "⚽"
                    )

                    playerSection(
                        title: "Top Assists",
                        players: stats.topAssists,
                        statValue: { $0.statistics.assists },
                        badge: "🅰️"
                    )

                    playerSection(
                        title: "Most Cards",
                        players: stats.topCards,
                        statValue: { $0.statistics.yellow + $0.statistics.red },
                        badge: "🟨"
                    )
                    
                    teamSection(stats.teams)
                }
                .padding()
            }
        }
        .task {
            if vm.stats == nil {
                await vm.fetchStats(
                    league: leagueId,
                    season: season
                )
            }
        }
        .onChange(of: season) {
            Task {
                await vm.fetchStats(
                    league: leagueId,
                    season: season
                )
            }
        }
    }
    
    private func statRow(
        title: String,
        team: String,
        value: Int
    ) -> some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(team)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Text("\(value)")
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private func playerSection(
        title: String,
        players: [PlayerStat],
        statValue: @escaping (PlayerStat) -> Int,
        badge: String
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text(title)
                .font(.headline)
            
            ForEach(players.prefix(5)) { player in
                HStack {
                    
                    AsyncImage(url: player.player.photo) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(player.player.name)
                            .font(.subheadline)
                        
                        Text(player.team.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        
                        Text(badge)
                        
                        Text("\(statValue(player))")
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private func teamSection(_ teams: TeamStats) -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Team Stats")
                .font(.headline)
            
            statRow(
                title: "Best Attack",
                team: teams.bestAttack.name,
                value: teams.bestAttack.goals ?? 0
            )
            
            statRow(
                title: "Best Defense",
                team: teams.bestDefense.name,
                value: teams.bestDefense.goalsAgainst ?? 0
            )
        }
    }
}

struct StandingsHeader: View {
    var body: some View {
        HStack {
            Text("#").frame(width: 30, alignment: .leading)
            Text("Team").frame(maxWidth: .infinity, alignment: .leading)
            Text("P").frame(width: 30)
            Text("W").frame(width: 30)
            Text("D").frame(width: 30)
            Text("L").frame(width: 30)
            Text("GF").frame(width: 40)
            Text("GA").frame(width: 40)
            Text("GD").frame(width: 40)
            Text("Pts").frame(width: 40)
        }
        .font(.caption)
        .foregroundColor(.gray)
    }
}

struct StandingsRowView: View {
    
    let row: StandingsRow
    let mode: StandingMode
    let leagueId: Int
    let season: Int
    
    var stats: Stats {
        switch mode {
        case .all:
            return row.all
        case .home:
            return Stats(
                played: row.home.played,
                win: row.home.win,
                draw: row.home.draw,
                lose: row.home.lose,
                goalsFor: 0,
                goalsAgainst: 0
            )
        case .away:
            return Stats(
                played: row.away.played,
                win: row.away.win,
                draw: row.away.draw,
                lose: row.away.lose,
                goalsFor: 0,
                goalsAgainst: 0
            )
        case .stats:
            return Stats(
                played: 0,
                win: 0,
                draw: 0,
                lose: 0,
                goalsFor: 0,
                goalsAgainst: 0
            )
        }
    }
    
    var body: some View {
        NavigationLink {
            TeamDetailsScreen(
                team: row.team,
                leagueId: leagueId,
                season: season
            )
        } label: {
            content
        }
        .buttonStyle(.plain)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            HStack {
                
                // Rank with color indicator
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(rankColor)
                        .frame(width: 4)
                    
                    Text("\(row.rank)")
                        .frame(width: 26)
                        .fontWeight(.bold)
                }
                
                AsyncImage(url: row.team.logo) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 24, height: 24)
                
                Text(row.team.name)
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(stats.played)").frame(width: 30)
                Text("\(stats.win)").frame(width: 30)
                Text("\(stats.draw)").frame(width: 30)
                Text("\(stats.lose)").frame(width: 30)
                
                Text("\(stats.goalsFor)").frame(width: 40)
                Text("\(stats.goalsAgainst)").frame(width: 40)
                
                Text("\(row.goalsDiff)")
                    .frame(width: 40)
                    .foregroundColor(row.goalsDiff >= 0 ? .green : .red)
                
                Text("\(row.points)")
                    .frame(width: 40)
                    .bold()
            }
            
            // FORM (only in ALL)
            if let form = row.form, mode == .all {
                HStack(spacing: 4) {
                    ForEach(Array(form.enumerated()), id: \.offset) { index, char in
                        Text(String(char))
                            .font(.caption2)
                            .frame(width: 18, height: 18)
                            .background(color(for: char))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.leading, 30)
            }
        }
        .padding(.vertical, 6)
        .background(rowBackground)
        .cornerRadius(8)
    }
    
    // 🔥 Rank coloring logic
    private var rankColor: Color {
        if row.rank <= 4 {
            return .green // Champions / playoffs
        } else if row.rank >= 16 {
            return .red // Relegation
        } else {
            return .clear
        }
    }
    
    private var rowBackground: Color {
        if row.rank <= 4 {
            return Color.green.opacity(0.08)
        } else if row.rank >= 16 {
            return Color.red.opacity(0.08)
        } else {
            return Color.clear
        }
    }
    
    func color(for char: Character) -> Color {
        switch char {
        case "W": return .green
        case "L": return .red
        case "D": return .gray
        default: return .clear
        }
    }
}

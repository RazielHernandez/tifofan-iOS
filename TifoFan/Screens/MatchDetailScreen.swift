//
//  MatchDetailScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

enum MatchTab: String, CaseIterable {
    case stats = "Stats"
    case lineups = "Lineups"
    case mxm = "MxM"
}

struct MatchDetailScreen: View {
    
    let matchId: Int
    
    @StateObject private var vm = MatchViewModel()
    @State private var selectedTab: MatchTab = .stats
    
    var body: some View {
        VStack {
            
            if vm.isLoading {
                ProgressView()
            } else if let match = vm.selectedMatch {
                
                // HEADER
                MatchHeaderView(match: match)
                
                // TAB BAR
                HStack {
                    ForEach(MatchTab.allCases, id: \.self) { tab in
                        Button {
                            selectedTab = tab
                        } label: {
                            Text(tab.rawValue)
                                .foregroundColor(selectedTab == tab ? .white : .blue)
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == tab ? Color.blue : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // CONTENT
                ScrollView {
                    switch selectedTab {
                    case .stats:
                        StatsMatchView(stats: vm.statistics, match: match)
                    case .lineups:
                        LineupsView(matchId: matchId)
                    case .mxm:
                        MatchEventsScreen(matchId: matchId)
                    }
                }
            }
        }
        .navigationTitle("Match")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchMatchDetail(matchId: matchId)
            await vm.fetchMatchStatistics(matchId: matchId)
        }
    }
}

struct MatchHeaderView: View {
    
    let match: MatchDetail
    
    var body: some View {
        VStack(spacing: 12) {
            
            HStack {
                TeamBlock(team: match.home.team)
                Spacer()
                ScoreBlock(match: match)
                Spacer()
                TeamBlock(team: match.away.team)
            }
            
            Text(match.status)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct TeamBlock: View {
    
    let team: TeamSummary
    
    var body: some View {
        VStack {
            AsyncImage(url: team.logo) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 50, height: 50)
            
            Text(team.name)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100)
    }
}

struct ScoreBlock: View {
    
    let match: MatchDetail
    
    var body: some View {
        VStack {
            Text("\(goals(match.home.goals)) - \(goals(match.away.goals))")
                .font(.title)
                .bold()
            
            Text(match.date, style: .time)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    private func goals(_ value: Int?) -> String {
        if let value = value {
            return "\(value)"
        } else {
            return "-"
        }
    }
}

struct OverviewView: View {
    
    let match: MatchDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Match Info")
                .font(.headline)
            
            HStack {
                Text("League")
                Spacer()
                Text(match.leagueId.description)
            }
            
            HStack {
                Text("Date")
                Spacer()
                Text(match.date, style: .date)
            }
            
            HStack {
                Text("Venue")
                Spacer()
                Text(match.venue ?? "N/A")
            }
        }
        .padding()
    }
}

struct StatsMatchView: View {
    
    let stats: [TeamMatchStatistics]
    let match: MatchDetail
    
    var body: some View {
        VStack(spacing: 12) {
            
            VStack(spacing: 12) {
                HStack {
                    Text("Date")
                    Spacer()
                    Text(match.date, style: .date)
                }
                
                HStack {
                    Text("Venue")
                    Spacer()
                    Text(match.venue ?? "N/A")
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            
            VStack(spacing:12) {
                ForEach(statItems(), id: \.title) { item in
                    StatBarRow(
                        item: item,
                    )
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
        }
        .padding()
    }
    
    private func statItems() -> [StatItemModel] {
        guard stats.count == 2 else { return [] }
        
        let home = stats[0].stats
        let away = stats[1].stats
        
        return [
            StatItemModel("Shots on Goal", home.shotsOnGoal ?? 0, away.shotsOnGoal ?? 0, icon: "scope"),
            StatItemModel("Total Shots", home.totalShots ?? 0, away.totalShots ?? 0, icon: "soccerball"),
            StatItemModel("Possession", home.possession ?? 0, away.possession ?? 0, icon: "chart.pie.fill", isPercentage: true),
            StatItemModel("Passes", home.passes ?? 0, away.passes ?? 0, icon: "arrow.left.arrow.right"),
            StatItemModel("Corners", home.corners ?? 0, away.corners ?? 0, icon: "flag.fill"),
            StatItemModel("Fouls", home.fouls ?? 0, away.fouls ?? 0, icon: "exclamationmark.triangle"),
            StatItemModel("Offsides", home.offsides ?? 0, away.offsides ?? 0, icon: "figure.run"),
            StatItemModel("Yellow Cards", home.yellowCards?.value ?? 0, away.yellowCards?.value ?? 0, icon: "square.fill"),
            StatItemModel("Red Cards", home.redCards?.value ?? 0, away.redCards?.value ?? 0, icon: "stop.fill")
        ]
    }
}

struct StatItemModel: Identifiable {
    let id = UUID()
    let title: String
    let home: Int
    let away: Int
    let icon: String
    let isPercentage: Bool
    
    init(_ title: String, _ home: Int, _ away: Int, icon: String, isPercentage: Bool = false) {
        self.title = title
        self.home = home
        self.away = away
        self.icon = icon
        self.isPercentage = isPercentage
    }
}

struct StatBarRow: View {
    
    let item: StatItemModel
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 8) {
            
            // HEADER (values + icon + title)
            HStack {
                Text(displayValue(item.home))
                    .fontWeight(.semibold)
                    .foregroundColor(color(for: item.home, opponent: item.away))
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: item.icon)
                        .font(.caption)
                    Text(item.title)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                Text(displayValue(item.away))
                    .fontWeight(.semibold)
                    .foregroundColor(color(for: item.away, opponent: item.home))
            }
            
            // BAR
            GeometryReader { geo in
                let halfWidth = geo.size.width / 2
                
                ZStack {
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 2)
                    
                    // BACKGROUND TRACK (optional)
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                    
                    HStack(spacing: 0) {
                        
                        // HOME (LEFT SIDE)
                        HStack {
                            Spacer()
                            
                            Rectangle()
                                .fill(homeGradient)
                                .frame(
                                    width: animate
                                    ? barWidth(total: halfWidth, value: item.home)
                                    : 0
                                )
                        }
                        .frame(width: halfWidth)
                        
                        // AWAY (RIGHT SIDE)
                        HStack {
                            Rectangle()
                                .fill(awayGradient)
                                .frame(
                                    width: animate
                                    ? barWidth(total: halfWidth, value: item.away)
                                    : 0
                                )
                            
                            Spacer()
                        }
                        .frame(width: halfWidth)
                    }
                }
                .animation(.easeOut(duration: 0.8), value: animate)
            }
            .frame(height: 10)
        }
        .onAppear {
            animate = true
        }
    }
    
    // MARK: - Helpers
    
    private func displayValue(_ value: Int) -> String {
        item.isPercentage ? "\(value)%" : "\(value)"
    }
    
    private func barWidth(total: CGFloat, value: Int) -> CGFloat {
        if item.isPercentage {
            return total * CGFloat(value) / 100.0
        }
        
        let sum = max(item.home + item.away, 1)
        return total * CGFloat(value) / CGFloat(sum)
    }
    
    private func color(for value: Int, opponent: Int) -> Color {
        if value > opponent { return .green }
        if value < opponent { return .red }
        return .gray
    }
    
    // MARK: - Gradients
    
    private var homeGradient: LinearGradient {
        LinearGradient(
            colors: [Color.blue.opacity(0.7), Color.blue],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var awayGradient: LinearGradient {
        LinearGradient(
            colors: [Color.red, Color.red.opacity(0.7)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct LineupsView: View {
    
    let matchId: Int
    @StateObject private var vm = LineupViewModel()
    
    var body: some View {
        VStack {
            
            if vm.isLoading {
                ProgressView()
            } else if vm.lineups.count == 2 {
                
                ScrollView {
                    VStack(spacing: 16) {
                        FormationView(
                            home: vm.lineups[0],
                            away: vm.lineups[1]
                        )
                        
                        Divider().padding(.vertical)
                        
                        SubstitutesView(
                            homeSubs: vm.lineups[0].substitutes,
                            awaySubs: vm.lineups[1].substitutes
                        )
                    }
                    .padding(.bottom, 20)
                }
                
                
            }
        }
        .task {
            await vm.fetchLineups(matchId: matchId)
        }
    }
}

struct FormationView: View {
    
    let home: TeamLineup
    let away: TeamLineup
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Formation")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ZStack {
                
                // FIELD
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.green.opacity(0.8), Color.green.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack {
                    
                    // AWAY TEAM (top)
                    PlayersGrid(players: away.startXI, isHome: false)
                    
                    Spacer()
                    
                    Divider()
                        .background(Color.white)
                    
                    Spacer()
                    
                    // HOME TEAM (bottom)
                    PlayersGrid(players: home.startXI, isHome: true)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .padding()
    }
}

struct PlayersGrid: View {
    
    let players: [LineupPlayer]
    let isHome: Bool
    
    var grouped: [Int: [LineupPlayer]] {
        Dictionary(grouping: players) { player in
            Int(player.grid?.split(separator: ":").first ?? "0") ?? 0
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(grouped.keys.sorted(), id: \.self) { row in
                
                HStack(spacing: 12) {
                    ForEach(grouped[row] ?? []) { player in
                        PlayerView(player: player, isHome: isHome)
                    }
                }
            }
        }
    }
}

struct PlayerView: View {
    
    let player: LineupPlayer
    let isHome: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            
            Text("\(player.number ?? 0)")
                .font(.caption)
                .bold()
                .frame(width: 28, height: 28)
                .background(isHome ? Color.blue : Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            Text(shortName(player.name))
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
    
    private func shortName(_ name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count > 1 {
            return "\(parts.first!.prefix(1)). \(parts.last!)"
        }
        return name
    }
}

struct SubstitutesView: View {
    
    let homeSubs: [LineupPlayer]
    let awaySubs: [LineupPlayer]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Substitutes")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            HStack(alignment: .top, spacing: 12) {
                
                // HOME
                VStack(spacing: 8) {
                    ForEach(homeSubs) { player in
                        PlayerLineupRow(player: player, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // AWAY
                VStack(spacing: 8) {
                    ForEach(awaySubs) { player in
                        PlayerLineupRow(player: player, alignment: .trailing)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 4)
            )
            .padding(.horizontal)
        }
    }
}

struct PlayerLineupRow: View {
    
    let player: LineupPlayer
    let alignment: HorizontalAlignment
    
    var body: some View {
        HStack {
            
            if alignment == .leading {
                number
                name
                Spacer()
            } else {
                Spacer()
                name
                number
            }
        }
        .font(.subheadline)
    }
    
    private var number: some View {
        Text("\(player.number ?? 0)")
            .font(.caption)
            .fontWeight(.bold)
            .frame(width: 28, height: 28)
            .background(Color.blue.opacity(0.15))
            .clipShape(Circle())
    }
    
    private var name: some View {
        Text(player.name)
            .lineLimit(1)
    }
}

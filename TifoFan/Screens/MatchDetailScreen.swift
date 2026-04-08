//
//  MatchDetailScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

enum MatchTab: String, CaseIterable {
    case overview = "Overview"
    case stats = "Stats"
    case lineups = "Lineups"
}

struct MatchDetailScreen: View {
    
    let matchId: Int
    
    @StateObject private var vm = MatchViewModel()
    @State private var selectedTab: MatchTab = .overview
    
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
                    case .overview:
                        OverviewView(match: match)
                    case .stats:
                        StatsMatchView(stats: vm.statistics)
                    case .lineups:
                        Text("Lineups coming soon")
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
            Text("\(match.home.goals) - \(match.away.goals)")
                .font(.title)
                .bold()
            
            Text(match.date, style: .time)
                .font(.caption)
                .foregroundColor(.gray)
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
    
    var body: some View {
        VStack(spacing: 12) {
            
            ForEach(statItems(), id: \.title) { item in
                StatBarRow(
                    item: item,
                )
            }
        }
        .padding()
    }
    
//    private func statItems() -> [StatItemModel] {
//        guard stats.count == 2 else { return [] }
//        
//        let home = stats[0]
//        let away = stats[1]
//        
//        return [
//            StatItemModel(title: "Shots", home: home.stats.shotsOnGoal ?? 0, away: away.stats.shotsOnGoal ?? 0),
//            StatItemModel(title: "Possession", home: home.stats.possession ?? 0,  away: away.stats.possession ?? 0),
//            StatItemModel(title: "Passes", home: home.stats.passes ?? 0, away: away.stats.passes ?? 0)
//        ]
//    }
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

//struct StatBarRow: View {
//    
//    let title: String
//    let homeValue: Int
//    let awayValue: Int
//    
//    var body: some View {
//        VStack {
//            
//            HStack {
//                Text("\(homeValue)")
//                Spacer()
//                Text(title)
//                Spacer()
//                Text("\(awayValue)")
//            }
//            
//            GeometryReader { geo in
//                HStack(spacing: 0) {
//                    
//                    Rectangle()
//                        .frame(width: barWidth(total: geo.size.width, value: homeValue))
//                    
//                    Rectangle()
//                        .frame(width: barWidth(total: geo.size.width, value: awayValue))
//                }
//            }
//            .frame(height: 8)
//        }
//    }
//    
//    private func barWidth(total: CGFloat, value: Int) -> CGFloat {
//        let sum = max(homeValue + awayValue, 1)
//        return total * CGFloat(value) / CGFloat(sum)
//    }
//}

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

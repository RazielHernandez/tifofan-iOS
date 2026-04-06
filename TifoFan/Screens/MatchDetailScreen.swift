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
                    title: item.title,
                    homeValue: item.home,
                    awayValue: item.away
                )
            }
        }
        .padding()
    }
    
    private func statItems() -> [StatItemModel] {
        guard stats.count == 2 else { return [] }
        
        let home = stats[0]
        let away = stats[1]
        
        return [
            StatItemModel(title: "Shots", home: home.stats.shotsOnGoal ?? 0, away: away.stats.shotsOnGoal ?? 0),
            StatItemModel(title: "Possession", home: home.stats.possession ?? 0,  away: away.stats.possession ?? 0),
            StatItemModel(title: "Passes", home: home.stats.passes ?? 0, away: away.stats.passes ?? 0)
        ]
    }
}

struct StatItemModel {
    let title: String
    let home: Int
    let away: Int
}

struct StatBarRow: View {
    
    let title: String
    let homeValue: Int
    let awayValue: Int
    
    var body: some View {
        VStack {
            
            HStack {
                Text("\(homeValue)")
                Spacer()
                Text(title)
                Spacer()
                Text("\(awayValue)")
            }
            
            GeometryReader { geo in
                HStack(spacing: 0) {
                    
                    Rectangle()
                        .frame(width: barWidth(total: geo.size.width, value: homeValue))
                    
                    Rectangle()
                        .frame(width: barWidth(total: geo.size.width, value: awayValue))
                }
            }
            .frame(height: 8)
        }
    }
    
    private func barWidth(total: CGFloat, value: Int) -> CGFloat {
        let sum = max(homeValue + awayValue, 1)
        return total * CGFloat(value) / CGFloat(sum)
    }
}



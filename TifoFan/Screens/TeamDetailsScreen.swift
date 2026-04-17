//
//  TeamDetailsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

enum TeamTab: String, CaseIterable {
    case overview = "Overview"
    case players = "Players"
    case matches = "Matches"
}

struct TeamDetailsScreen: View {
    
    let team: TeamSummary
    let leagueId: Int
    
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @StateObject private var vm = TeamDetailsViewModel()
    @StateObject private var matchVM = MatchViewModel()
    @State private var selectedTab: TeamTab = .overview
    
    
    private let season = 2025
    
    private var isFavorite: Bool {
        favoritesVM.favoriteTeamIds.contains(team.id)
    }
    
    private var sortedMatches: [Match] {
        matchVM.matches.sorted { $0.date < $1.date }
    }

    private var now: Date {
        Date()
    }

    // ⏮ Finished matches
    private var previousMatches: [Match] {
        sortedMatches.filter { $0.date < now }
    }

    // ⭐ Next match (first upcoming)
    private var nextMatch: Match? {
        sortedMatches.first { $0.date >= now }
    }

    // ⏭ Future matches (excluding next)
    private var futureMatches: [Match] {
        guard let next = nextMatch else { return [] }
        return sortedMatches.filter { $0.date > next.date }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // HEADER CARD
                headerView
                
                // TAB BAR
                tabBar
                
                // CONTENT
                contentView
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(team.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
        .task {
            if vm.teamDetail == nil {
                await vm.fetchTeamDetails(
                    teamId: team.id,
                    leagueId: leagueId,
                    season: season
                )
            }
            
            if favoritesVM.favoriteTeamIds.isEmpty {
                await favoritesVM.fetchFavorites()
            }
            
            if matchVM.matches.isEmpty {
                await matchVM.fetchMatchesByTeam(
                    teamId: team.id,
                    season: season
                )
            }
        }
    }
    
    
    private var favoriteButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            Task {
                await favoritesVM.toggleTeam(team)
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
                .scaleEffect(isFavorite ? 1.2 : 1.0)
                .animation(.spring(response: 0.3), value: isFavorite)
        }
    }
}


extension TeamDetailsScreen {
    
    private var headerView: some View {
        VStack(spacing: 12) {
            
            AsyncImage(url: team.logo) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .shadow(radius: 4)
            
            Text(team.name)
                .font(.title2)
                .fontWeight(.bold)
            
            if isFavorite {
                Text("★ Favorite")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Text("Season \(season)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
    
    private var tabBar: some View {
        HStack(spacing: 8) {
            ForEach(TeamTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut) {
                        selectedTab = tab
                    }
                } label: {
                    Text(tab.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedTab == tab ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedTab == tab
                            ? Color.blue
                            : Color(.secondarySystemBackground)
                        )
                        .cornerRadius(10)
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if vm.isLoading {
            ProgressView()
                .padding()
        } else if let details = vm.teamDetail {
            
            switch selectedTab {
                
                case .overview:
                    overviewView(details: details)
                    
                case .players:
                    TeamPlayersListView(
                        teamId: team.id,
                        leagueId: leagueId
                    )
                case .matches:
                    matchesView
                
            }
        
        }
    }
    
    private var matchesView: some View {
        
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 24) {
                    
                    ForEach(sortedMatches) { match in
                        
                        if match.id == nextMatch?.id {
                            Text("TODAY")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        }
                        
                        TimelineMatchRow(
                            match: match,
                            teamId: team.id,
                            isNext: match.id == nextMatch?.id
                        )
                        .id(match.id)
                    }
                }
                .padding(.vertical)
                .onAppear {
                    scrollToRelevantMatch(proxy: proxy)
                }
                .onChange(of: matchVM.matches) {
                    scrollToRelevantMatch(proxy: proxy)
                }
            }
        }
    }
    
    private func scrollToRelevantMatch(proxy: ScrollViewProxy) {
        
        guard !sortedMatches.isEmpty else { return }
        
        DispatchQueue.main.async {
            if let next = nextMatch {
                proxy.scrollTo(next.id, anchor: .center)
            } else if let last = sortedMatches.last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
    
    private func matchRow(_ match: Match, highlight: Bool = false) -> some View {
        NavigationLink {
            MatchDetailScreen(matchId: match.id)
        } label: {
            TeamMatchRow(
                match: match,
                teamId: team.id
            )
            .scaleEffect(highlight ? 1.02 : 1)
            .background(
                highlight
                ? Color.blue.opacity(0.08)
                : Color.clear
            )
            .cornerRadius(12)
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    struct TeamMatchRow: View {
        
        let match: Match
        let teamId: Int
        
        private var isHome: Bool {
            match.home.team.id == teamId
        }
        
        private var isWinner: Bool {
            guard
                let teamGoals = isHome ? match.home.goals : match.away.goals,
                let opponentGoals = isHome ? match.away.goals : match.home.goals
            else {
                return false // not played yet
            }
            
            return teamGoals > opponentGoals
        }
        
        
        
        var body: some View {
            HStack(spacing: 12) {
                
                // TEAM LOGO
                AsyncImage(url: isHome ? match.home.team.logo : match.away.team.logo) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(isHome ? "vs \(match.away.team.name)" : "@ \(match.home.team.name)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(match.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    if let homeGoals = match.home.goals,
                       let awayGoals = match.away.goals {
                        
                        Text("\(homeGoals) - \(awayGoals)")
                            .fontWeight(.bold)
                        
                    } else {
                        Text("vs")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(match.displayStatus)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(
                isWinner
                ? Color.green.opacity(0.08)
                : Color(.systemBackground)
            )
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
    
    
}



extension TeamDetailsScreen {
    
    private func overviewView(details: TeamDetails) -> some View {
        VStack(spacing: 16) {
            
            // MAIN STATS CARD
            VStack(spacing: 12) {
                
                statRow("Matches", "\(details.aggregates.matchesPlayed)")
                statRow("Wins", "\(details.aggregates.wins)")
                statRow("Draws", "\(details.aggregates.draws)")
                statRow("Losses", "\(details.aggregates.losses)")
                
                Divider()
                
                statRow("Goals For", "\(details.aggregates.goalsFor)")
                statRow("Goals Against", "\(details.aggregates.goalsAgainst)")
                statRow("Goal Diff", "\(details.aggregates.goalDifference)",
                        valueColor: details.aggregates.goalDifference >= 0 ? .green : .red)
                
                Divider()
                
                statRow("Points", "\(details.aggregates.points)", bold: true)
            }
            
            // ADVANCED STATS
            VStack(spacing: 12) {
                statRow("Win Rate", details.aggregates.winRate.percentage())
                statRow("Goals / Match", details.aggregates.goalsForPerMatch.formatted(2))
                statRow("Conceded / Match", details.aggregates.goalsAgainstPerMatch.formatted(2))
                
            }
        }
    }
    
    private func statRow(
        _ title: String,
        _ value: String,
        valueColor: Color = .primary,
        bold: Bool = false
    ) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .foregroundColor(valueColor)
                .fontWeight(bold ? .bold : .semibold)
        }
        .font(.subheadline)
    }
}

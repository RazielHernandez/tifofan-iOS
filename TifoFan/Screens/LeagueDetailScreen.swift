//
//  LeagueDetailScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

enum LeagueTab: String, CaseIterable {
    case teams = "Teams"
    case standings = "Standings"
    case fixtures = "Fixtures"
    case news = "News"
}

struct LeagueDetailView: View {
    
    let league: League
    
    @State private var selectedTab: LeagueTab = .teams
    
    var body: some View {
        VStack {
            
            // HEADER
            VStack(spacing: 12) {
                AsyncImage(url: league.logo) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 80, height: 80)
                
//                Text(league.name)
//                    .font(.title2)
//                    .bold()
//                
//                Text(league.country)
//                    .foregroundColor(.gray)
            }
            .padding()
            
            // TAB BAR
            HStack {
                ForEach(LeagueTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Text(tab.rawValue)
                            .font(.subheadline)
                            .foregroundColor(selectedTab == tab ? .white : .blue)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == tab ? Color.blue : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // CONTENT
            switch selectedTab {
            case .teams:
                TeamsView(league: league, vm: LeagueViewModel())
            case .standings:
                StandingsScreen(leagueId: league.id, season: 2025, vm: StandingsViewModel())
            case .fixtures:
                FixturesView(league: league, vm: MatchViewModel())
            case .news:
                Text("News coming soon")
                Spacer()
            }
        }
        .navigationTitle(league.name + "(" + league.country + ")")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct FixturesView: View {
    
    let league: League
    @ObservedObject var vm: MatchViewModel
    
    private let season = 2024
    
    var body: some View {
        VStack {
            if vm.isLoading {
                VStack {
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }
            } else if let error = vm.errorMessage {
                Text(error)
            } else {
                
                List(vm.matches) { match in
                    
                    NavigationLink {
                        MatchDetailScreen(matchId: match.id)
                    } label: {
                        MatchRow(match: match)
                    }
                }
            }
        }
        .task {
            await vm.fetchMatches(
                leagueId: league.id,
                season: season
            )
        }
    }
}

struct TeamPlayersListView: View {
    
    let teamId: Int
    let leagueId: Int
    
    @StateObject private var vm = TeamPlayersViewModel()
    
    private let season = 2024
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Players")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    
                    ForEach(vm.players) { player in
                        NavigationLink {
                            PlayerDetailScreen(playerId: player.id)
                        } label: {
                            PlayerRow(player: player)
                        }
                        .onAppear {
                            if player.id == vm.players.last?.id {
                                Task {
                                    await vm.fetchNextPage(
                                        teamId: teamId,
                                        leagueId: leagueId,
                                        season: season
                                    )
                                }
                            }
                        }
                    }
                    
                    if vm.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
            }
        }
        .task {
            await vm.fetchFirstPage(
                teamId: teamId,
                leagueId: leagueId,
                season: season
            )
        }
    }
}

struct StatsView: View {
    
    let stats: TeamAggregates
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stats")
                .font(.headline)
            
            HStack {
                StatItem(title: "Points", value: "\(stats.points)")
                StatItem(title: "Wins", value: "\(stats.wins)")
                StatItem(title: "Losses", value: "\(stats.losses)")
            }
            
            HStack {
                StatItem(title: "GF", value: "\(stats.goalsFor)")
                StatItem(title: "GA", value: "\(stats.goalsAgainst)")
                StatItem(title: "GD", value: "\(stats.goalDifference)")
            }
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value).bold()
            Text(title).font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PlayersSection: View {
    
    let players: [TeamPlayer]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Players")
                .font(.headline)
            
            ForEach(players) { player in
                PlayerRow(player: player)
            }
        }
    }
}

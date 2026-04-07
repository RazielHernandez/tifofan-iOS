//
//  TeamDetailsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

import SwiftUI

enum TeamTab: String, CaseIterable {
    case overview = "Overview"
    case players = "Players"
}

struct TeamDetailsScreen: View {
    
    let team: TeamSummary
    let leagueId: Int
    
    @StateObject private var vm = TeamDetailsViewModel()
    @State private var selectedTab: TeamTab = .overview
    
    private let season = 2024
    
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
        .task {
            if vm.teamDetail == nil {
                await vm.fetchTeamDetails(
                    teamId: team.id,
                    leagueId: leagueId,
                    season: season
                )
            }
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
            }
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
            //.cardStyle()
            
            // ADVANCED STATS
            VStack(spacing: 12) {
                statRow("Win Rate", details.aggregates.winRate.percentage())
                statRow("Goals / Match", details.aggregates.goalsForPerMatch.formatted(2))
                statRow("Conceded / Match", details.aggregates.goalsAgainstPerMatch.formatted(2))
                
            }
            //.cardStyle()
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

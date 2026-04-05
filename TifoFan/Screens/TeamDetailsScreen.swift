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
}

struct TeamDetailsScreen: View {
    
    let team: TeamSummary
    let leagueId: Int
    
    @StateObject private var vm = TeamDetailsViewModel()
    @State private var selectedTab: TeamTab = .players
    
    private let season = 2024
    
    var body: some View {
        VStack {
            
            if vm.isLoading {
                ProgressView()
            } else if let details = vm.teamDetail {
                
                // HEADER
                VStack(spacing: 12) {
                    AsyncImage(url: team.logo) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 80, height: 80)
                    
                    Text(team.name)
                        .font(.title2)
                        .bold()
                }
                .padding()
                
                // TAB BAR
                HStack {
                    ForEach(TeamTab.allCases, id: \.self) { tab in
                        Button {
                            selectedTab = tab
                        } label: {
                            Text(tab.rawValue)
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
                Group {
                    switch selectedTab {
                        
                    case .overview:
                        StatsView(stats: details.aggregates)
                        
                    case .players:
                        TeamPlayersListView(
                            teamId: team.id,
                            leagueId: leagueId
                        )
                    }
                }
            }
        }
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

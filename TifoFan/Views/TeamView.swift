//
//  Untitled.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

struct TeamsView: View {
    
    let league: League
    @ObservedObject var vm: LeagueViewModel
    
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    private let season = 2025
    
    private var favoriteTeams: [TeamSummary] {
        vm.teams.filter { favoritesVM.favoriteTeamIds.contains($0.id) }
    }

    private var otherTeams: [TeamSummary] {
        vm.teams.filter { !favoritesVM.favoriteTeamIds.contains($0.id) }
    }
    
    var body: some View {
        Group {
            if vm.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                
            } else if let error = vm.errorMessage {
                ErrorScreen(errorMessage: error)
                
            } else {
                ScrollView {
//                    LazyVStack(spacing: 12) {
//                        
//                        ForEach(vm.teams, id: \.id) { team in
//                            
//                            HStack {
//                                
//                                NavigationLink {
//                                    TeamDetailsScreen(
//                                        team: team,
//                                        leagueId: league.id
//                                    )
//                                } label: {
//                                    TeamRow(
//                                        team: team,
//                                        isFavorite: favoritesVM.favoriteTeamIds.contains(team.id),
//                                        onFavoriteTap: {
//                                            Task {
//                                                await favoritesVM.toggleTeam(team)
//                                            }
//                                        }
//                                    )
//                                }
//                                
//                                Spacer()
//                            }
//                        }
//                    }
//                    .padding()
                    LazyVStack(spacing: 16) {
                        
                        // ⭐ FAVORITES SECTION
                        if !favoriteTeams.isEmpty {
                            sectionHeader("Favorites")
                            
                            ForEach(favoriteTeams, id: \.id) { team in
                                teamRow(team)
                                    .id("fav-\(team.id)")
                            }
                        }
                        
                        // ⚽ ALL TEAMS
                        if !otherTeams.isEmpty {
                            sectionHeader("All Teams")
                            
                            ForEach(otherTeams, id: \.id) { team in
                                teamRow(team)
                                    .id("other-\(team.id)")
                            }
                        }
                    }
                    .animation(.easeInOut, value: favoritesVM.favoriteTeamIds)
                }
            }
        }
        .task {
            if vm.teams.isEmpty {
                await vm.fetchLeaguesWithTeams(
                    league: league.id,
                    season: season
                )
            }
            
            // 🔥 Load favorites (important)
            if favoritesVM.favoriteTeamIds.isEmpty {
                await favoritesVM.fetchFavorites()
            }
        }
    }
    
    private func teamRow(_ team: TeamSummary) -> some View {
        NavigationLink {
            TeamDetailsScreen(
                team: team,
                leagueId: league.id
            )
        } label: {
            TeamRow(
                team: team,
                isFavorite: Binding(
                    get: { favoritesVM.favoriteTeamIds.contains(team.id) },
                    set: { _ in }
                ),
                onFavoriteTap: {
                    Task {
                        await favoritesVM.toggleTeam(team)
                    }
                }
            )
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
}

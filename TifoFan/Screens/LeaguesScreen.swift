//
//  LeaguesScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-03.
//

import SwiftUI

struct LeaguesScreen: View {
    
    @StateObject private var viewModel = LeagueViewModel()
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    var body: some View {
        NavigationView {
            
            Group {
                if viewModel.isLoading || favoritesVM.isLoading {
                    ProgressView()
                    
                } else if let error = viewModel.errorMessage {
                    ErrorScreen(errorMessage: error)
                    
                } else {
                    List(
                        viewModel.leagues.sorted {
                            let isFav0 = favoritesVM.favoriteLeagueIds.contains($0.id)
                            let isFav1 = favoritesVM.favoriteLeagueIds.contains($1.id)
                            return isFav0 && !isFav1
                        }
                    ) { league in
                        
                        HStack {
                            
                            // Navigation content
                            NavigationLink {
                                LeagueDetailView(league: league)
                            } label: {
                                HStack {
                                    AsyncImage(url: league.logo) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading) {
                                        Text(league.name)
                                            .font(.headline)
                                        
                                        Text(league.country)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                Task {
                                    await favoritesVM.toggleLeague(league)
                                }
                            } label: {
                                Image(systemName:
                                        favoritesVM.favoriteLeagueIds.contains(league.id)
                                      ? "heart.fill"
                                      : "heart"
                                )
                                .foregroundColor(
                                    favoritesVM.favoriteLeagueIds.contains(league.id)
                                    ? .red
                                    : .gray
                                )
                                .scaleEffect(
                                    favoritesVM.favoriteLeagueIds.contains(league.id) ? 1.2 : 1.0
                                )
                                .animation(.spring(response: 0.3), value: favoritesVM.favoriteLeagueIds)
                            }
                            .buttonStyle(.plain)
                        }
                        .background(
                            favoritesVM.favoriteLeagueIds.contains(league.id)
                            ? Color.red.opacity(0.05)
                            : Color.clear
                        )
                        .cornerRadius(8)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Leagues")
        }
        .task {
            await viewModel.fetchLeagues()
            await favoritesVM.fetchFavorites()
        }
    }
}

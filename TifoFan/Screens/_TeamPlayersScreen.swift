//
//  _TeamPlayersScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import SwiftUI

struct TeamPlayersScreen: View {
    
    let teamId: Int
    let leagueId: Int
    let season: Int
    
    @StateObject private var vm = TeamPlayersViewModel()
    
    var body: some View {
        List {
            
            ForEach(vm.players) { player in
                playerRow(player)
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
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .navigationTitle("Squad")
        .task {
            await vm.fetchFirstPage(
                teamId: teamId,
                leagueId: leagueId,
                season: season
            )
        }
    }
    
    // MARK: - Player Row
    
    private func playerRow(_ player: TeamPlayer) -> some View {
        HStack(spacing: 16) {
            
            if let photo = player.photo,
               let url = URL(string: photo) {
                
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.3))
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .bold()
                
                if let position = player.position {
                    Text(position)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if let age = player.age {
                Text("\(age)")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    TeamPlayersScreen(teamId: 2286, leagueId: 262, season: 2023)
}

//
//  StandingsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-05.
//

import SwiftUI

struct StandingsScreen: View {
    
    let leagueId: Int
    let season: Int
    
    @ObservedObject var vm: StandingsViewModel
    
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
                    .foregroundColor(.red)
                
            } else {
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        
                        ForEach(vm.standings) { row in
                            
                            HStack(spacing: 12) {
                                
                                // Rank
                                Text("\(row.rank)")
                                    .frame(width: 30, alignment: .leading)
                                
                                // Team logo
                                AsyncImage(url: row.team.logo) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    case .failure(_):
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .opacity(0.5)
                                    default:
                                        ProgressView()
                                    }
                                }
                                .frame(width: 24, height: 24)
                                
                                // Team name
                                Text(row.team.name)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                // Points
                                Text("\(row.points)")
                                    .bold()
                                    .frame(width: 40, alignment: .trailing)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await vm.fetchStandings(league: leagueId, season: season)
        }
    }
}

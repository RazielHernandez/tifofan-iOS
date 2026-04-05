//
//  LeaguesScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-03.
//

import SwiftUI

struct LeaguesScreen: View {
    
    @StateObject private var viewModel = LeagueViewModel()
    
    var body: some View {
        NavigationView{
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                ErrorScreen(errorMessage: error)
            } else {
                List(viewModel.leagues) { league in
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
                }
                .navigationTitle("Leagues")
            }
        }
        .task {
            await viewModel.fetchLeagues()
        }
    }
}

#Preview {
    LeaguesScreen()
}

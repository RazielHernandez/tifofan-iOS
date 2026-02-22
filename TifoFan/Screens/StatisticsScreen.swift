//
//  StatiticsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-16.
//

import SwiftUI

struct StatisticsScreen: View {
    @StateObject private var viewModel = LeagueViewModel()
        
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                } else {
                    List(viewModel.leagues) { league in
                        Text(league.name)
                    }
                }
            }
            .navigationTitle("Leagues")
        }
        .task {
            await viewModel.fetchLeagues()
        }
    }
}

#Preview {
    StatisticsScreen()
}

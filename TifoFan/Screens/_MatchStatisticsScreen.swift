//
//  _MatchStatisticsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-25.
//

import SwiftUI

struct MatchStatisticsScreen: View {
    
    @StateObject private var viewModel = MatchViewModel()
        
    // Test values
    private let matchId = 1031276
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            }
            else if let error = viewModel.errorMessage {
                VStack {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 60))
                        .padding()
                    
                    Text(error)
                        .multilineTextAlignment(.center)
                }
            }
            else if viewModel.statistics.count == 2 {
                
                let home = viewModel.statistics[0]
                let away = viewModel.statistics[1]
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: Teams Header
                        HStack {
                            TeamHeaderView(team: home.team)
                            Spacer()
                            TeamHeaderView(team: away.team)
                        }
                        
                        Divider()
                        
                        // MARK: Stats Comparison
                        VStack(spacing: 16) {
                            
                            StatRow(
                                title: "Possession",
                                homeValue: percent(home.stats.possession),
                                awayValue: percent(away.stats.possession)
                            )
                            
                            StatRow(
                                title: "Total Shots",
                                homeValue: value(home.stats.totalShots),
                                awayValue: value(away.stats.totalShots)
                            )
                            
                            StatRow(
                                title: "Shots on Goal",
                                homeValue: value(home.stats.shotsOnGoal),
                                awayValue: value(away.stats.shotsOnGoal)
                            )
                            
                            StatRow(
                                title: "Corners",
                                homeValue: value(home.stats.corners),
                                awayValue: value(away.stats.corners)
                            )
                            
                            StatRow(
                                title: "Fouls",
                                homeValue: value(home.stats.fouls),
                                awayValue: value(away.stats.fouls)
                            )
                            
                            StatRow(
                                title: "Yellow Cards",
                                homeValue: value(home.stats.yellowCards),
                                awayValue: value(away.stats.yellowCards)
                            )
                            
                            StatRow(
                                title: "Red Cards",
                                homeValue: value(home.stats.redCards),
                                awayValue: value(away.stats.redCards)
                            )
                            
                            StatRow(
                                title: "Passes",
                                homeValue: value(home.stats.passes),
                                awayValue: value(away.stats.passes)
                            )
                            
                            StatRow(
                                title: "Pass Accuracy",
                                homeValue: percent(home.stats.passAccuracy),
                                awayValue: percent(away.stats.passAccuracy)
                            )
                        }
                    }
                    .padding()
                }
            }
            else {
                Text("Nothing to show")
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMatchStatistics(matchId: matchId)
        }
    }
}

struct TeamHeaderView: View {
    let team: TeamSummary
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: team.logo)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            Text(team.name)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}

struct StatRow: View {
    
    let title: String
    let homeValue: String
    let awayValue: String
    
    var body: some View {
        HStack {
            
            Text(homeValue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(title)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
            
            Text(awayValue)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

private func value(_ number: Int?) -> String {
    guard let number else { return "-" }
    return "\(number)"
}

private func percent(_ number: Int?) -> String {
    guard let number else { return "-" }
    return "\(number)%"
}

#Preview {
    MatchStatisticsScreen()
}

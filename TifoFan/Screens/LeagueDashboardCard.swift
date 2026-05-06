//
//  LeagueDashboardCard.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-05-05.
//

import SwiftUI

struct LeagueDashboardCard: View {
    
    let league: LeagueFavorite
    let season: Int
    
    @ObservedObject var matchesVM: MatchViewModel
    @StateObject private var statsVM = LeagueStatsViewModel()
    
    var body: some View {
        
        let primary = Color.blue
        let secondary = Color.purple
        
        ScrollView {
            VStack(spacing: 16) {
                
                LeagueHeader(league: league)
                
                // ⚽ NEXT MATCH
                NextLeagueMatchSection(
                    matches: matchesVM.nextMatchesByLeague[league.id],
                    isLoading: matchesVM.nextMatchesByLeague[league.id] == nil
                )
                .id(matchesVM.nextMatchesByLeague[league.id]?.count ?? 0)
                
                if statsVM.isLoading && statsVM.stats == nil {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                
                if let stats = statsVM.stats {
                    
                    // 🔥 TOP SCORING TEAMS
                    TopScoringTeamsSection(teams: stats.teams.topScoringTeams)
                    
                    Divider().opacity(0.6)
                    
                    // 🎯 TOP SCORERS
                    TopScorersSection(players: stats.topScorers)
                    
                    Divider().opacity(0.6)
                    
                    // 📊 INSIGHTS
                    LeagueInsightsSection(teams: stats.teams)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [
                    primary.opacity(0.5),
                    secondary.opacity(0.4),
                    primary.opacity(0.2),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .scrollIndicators(.hidden)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .task {
            await matchesVM.fetchNextMatches(
                leagueId: league.id,
                season: season,
                next: 5
            )
            
            await statsVM.fetchStats(
                league: league.id,
                season: season
            )
        }
    }
}

struct TopScoringTeamsSection: View {
    
    let teams: [TeamGoalStat]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Label("Top Attacking Teams", systemImage: "flame")
                .font(.headline)
            
            ForEach(teams.prefix(5)) { team in
                HStack {
                    
                    AsyncImage(url: team.logo) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 24, height: 24)
                    
                    Text(team.name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(team.goals ?? 0)")
                        .font(.subheadline.bold())
                }
            }
        }
    }
}

struct TopScorersSection: View {
    
    let players: [PlayerStat]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Label("Top Scorers", systemImage: "sportscourt")
                .font(.headline)
            
            ForEach(players.prefix(3)) { playerStat in
                HStack(spacing: 10) {
                    
                    AsyncImage(url: playerStat.player.photo) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(playerStat.player.name)
                            .font(.subheadline)
                        
                        Text(playerStat.team.name)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("\(playerStat.statistics.goals)")
                        .font(.headline.bold())
                }
            }
        }
    }
}

struct LeagueInsightsSection: View {
    
    let teams: TeamStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Label("League Insights", systemImage: "chart.bar")
                .font(.headline)
            
            HStack(spacing: 12) {
                
                insightCard(
                    title: "Best Attack",
                    team: teams.bestAttack,
                    value: teams.bestAttack.goals ?? 0
                )
                
                insightCard(
                    title: "Best Defense",
                    team: teams.bestDefense,
                    value: teams.bestDefense.goalsAgainst ?? 0
                )
            }
        }
    }
    
    private func insightCard(title: String, team: TeamGoalStat, value: Int) -> some View {
        VStack(spacing: 6) {
            
            AsyncImage(url: team.logo) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 28, height: 28)
            
            Text(team.name)
                .font(.caption)
                .lineLimit(1)
            
            Text("\(value)")
                .font(.headline.bold())
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

struct NextLeagueMatchSection: View {
    
    let matches: [Match]?
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Label("Upcoming Matches", systemImage: "calendar")
                .font(.headline)
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                
            } else if let matches, !matches.isEmpty {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(matches.prefix(5)) { match in
                            NavigationLink {
                                MatchDetailScreen(matchId: match.id)
                            } label: {
                                LeagueMatchCard(match: match)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                
            } else {
                Text("No upcoming matches")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .animation(.easeInOut, value: matches?.first?.id)
    }
}

struct LeagueMatchCard: View {
    
    let match: Match
    
    var body: some View {
        VStack(spacing: 10) {
            
            if match.status == "LIVE" {
                Text("LIVE")
                    .font(.caption2)
                    .padding(4)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(6)
            }
            
            // 🏷 STATUS / DATE
            Text(formatDate(match.date))
                .font(.caption2)
                .foregroundColor(.gray)
            
            // 🏟 TEAMS
            HStack(spacing: 8) {
                
                teamView(
                    name: match.home.team.name,
                    logo: match.home.team.logo
                )
                
                Text("vs")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                teamView(
                    name: match.away.team.name,
                    logo: match.away.team.logo
                )
            }
        }
        .padding()
        .frame(width: 180)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private func teamView(name: String, logo: URL?) -> some View {
        VStack(spacing: 4) {
            
            AsyncImage(url: logo) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 28, height: 28)
            
            Text(shortName(name))
                .font(.caption2)
                .lineLimit(1)
        }
    }
    
    private func shortName(_ name: String) -> String {
        name.components(separatedBy: " ").first ?? name
    }
    
    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMM d • HH:mm"
        return f.string(from: date)
    }
}

//
//struct TopTeamsSection: View {
//    
//    let standings: [Standing]
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            
//            Label("Top Teams", systemImage: "trophy")
//                .font(.headline)
//            
//            ForEach(standings.prefix(5)) { team in
//                HStack {
//                    Text("#\(team.rank)")
//                    Text(team.name)
//                    Spacer()
//                    Text("\(team.points) pts")
//                        .fontWeight(.semibold)
//                }
//                .font(.subheadline)
//            }
//        }
//    }
//}
//
//struct TopScorersSection: View {
//    
//    let players: [Player]
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            
//            Label("Top Scorers", systemImage: "flame")
//                .font(.headline)
//            
//            ForEach(players.prefix(3)) { player in
//                HStack {
//                    Text(player.name)
//                    Spacer()
//                    Text("\(player.goals)")
//                        .fontWeight(.bold)
//                }
//                .font(.subheadline)
//            }
//        }
//    }
//}
//
//struct LeagueInsightsSection: View {
//    
//    let stats: LeagueStats
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            
//            Label("League Insights", systemImage: "chart.bar")
//                .font(.headline)
//            
//            HStack {
//                insightCard("Best Attack", stats.bestAttackTeam)
//                insightCard("Best Defense", stats.bestDefenseTeam)
//            }
//        }
//    }
//    
//    private func insightCard(_ title: String, _ value: String) -> some View {
//        VStack {
//            Text(value)
//                .font(.headline.bold())
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 8)
//        .background(Color.white.opacity(0.05))
//        .cornerRadius(10)
//    }
//}

//
//  DashboardScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-16.
//

import SwiftUI
import SwiftData

struct DashboardScreen: View {
    
    @StateObject private var matchesVM = MatchViewModel()
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject var tifoVM: TifoViewModel
    
    
    var body: some View {
        NavigationView {
            
            TabView {
                
                // 🏠 GENERAL CARD
                GeneralDashboardCard()
                
                ForEach(favoritesVM.favoriteLeagues) { league in
                    LeagueDashboardCard(
                        league: league,
                        season: 2024,
                        matchesVM: matchesVM
                    )
                }

                ForEach(favoritesVM.favoriteTeams) { team in
                    TeamDashboardCard(
                        team: team,
                        season: 2024,
                        matchesVM: matchesVM
                    )
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .task {
                tifoVM.setContext(context)

                await favoritesVM.fetchFavorites()

                for team in favoritesVM.favoriteTeams {
                    tifoVM.loadLocalTifo(teamId: team.id)
                }
            }
        }
    }
}

struct GeneralDashboardCard: View {
    
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
//                NavigationLink {
//                    TifoGeneratorScreen(favoritesVM: favoritesVM)
//                } label: {
//                    TifoCard()
//                }
//                .buttonStyle(.plain)
                
                QuickActions()
                
                MatchesSection(title: "Important Matches")
                
                NewsSection()
                
                QuickStatsSection()
            }
            .padding()
        }
    }
}

struct MatchesSection: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(title)
                .font(.headline)

            ForEach(0..<3) { _ in
                DashboardMatchRow()
            }
        }
    }
}

struct LeagueDashboardCard: View {
    
    let league: LeagueFavorite
    let season: Int
    @ObservedObject var matchesVM: MatchViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // 🔥 HEADER
                LeagueHeader(league: league)
                
                // ⚽ NEXT / LIVE MATCH
                if let match = matchesVM.nextMatch(for: league.id) {
                    MatchHighlightCard(match: match)
                } else {
                    Text("No upcoming matches")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // 📊 STANDINGS PREVIEW
                StandingsPreview(leagueId: league.id)
                
            }
            .padding()
        }
        .task {
            await matchesVM.fetchMatches(
                leagueId: league.id,
                season: season
            )
        }
    }
}

struct TifoCard: View {

    let grid: TifoGrid?

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            TifoView(grid: grid)
                .frame(height: 200)

            LinearGradient(
                colors: [.black.opacity(0.7), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .cornerRadius(16)

            VStack(alignment: .leading, spacing: 6) {
                Text("Create Your Tifo")
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Design and share with fans")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
    }
}

struct DashboardMatchRow: View {
    var body: some View {
        HStack {

            VStack(alignment: .leading, spacing: 4) {
                Text("Team A vs Team B")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("Today • 18:00")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("Live")
                .font(.caption2)
                .padding(6)
                .background(Color.red.opacity(0.2))
                .foregroundColor(.red)
                .cornerRadius(6)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct LeagueHeader: View {
    let league: LeagueFavorite
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: league.logo ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(league.name)
                    .font(.headline)
                Text(league.country ?? "N/A")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

struct MatchHighlightCard: View {
    
    let match: Match
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text(match.status)
                .font(.caption)
                .foregroundColor(.red)
            
            HStack {
                
                Text(match.home.team.name)
                Spacer()
                Text("vs")
                Spacer()
                Text(match.away.team.name)
            }
            .font(.headline)
            
            Text(match.date.description)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 3)
    }
}

struct StandingsPreview: View {
    
    let leagueId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Standings")
                .font(.headline)
            
            ForEach(0..<5) { i in
                HStack {
                    Text("#\(i+1)")
                    Text("Team \(i+1)")
                    Spacer()
                    Text("\(10 - i) pts")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct NewsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Latest News")
                .font(.headline)

            ForEach(0..<3) { _ in
                NewsRow()
            }
        }
    }
}

struct NewsRow: View {
    var body: some View {
        HStack(spacing: 12) {

            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text("Big match coming this weekend")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                Text("ESPN • 2h ago")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct QuickActions: View {
    var body: some View {
        HStack(spacing: 12) {
            ActionButton(title: "Edit", icon: "pencil")
            ActionButton(title: "Publish", icon: "paperplane")
            ActionButton(title: "Explore", icon: "globe")
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .clipShape(Circle())

            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - QUICK STATS

struct QuickStatsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Quick Stats")
                .font(.headline)

            HStack(spacing: 12) {
                StatCard(title: "Top Scorer", value: "Mbappé")
                StatCard(title: "Top Team", value: "Man City")
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

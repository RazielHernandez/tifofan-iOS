//
//  DashboardScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-16.
//

import SwiftUI

import SwiftUI

struct DashboardScreen: View {
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 🔥 TIFO CARD
                    TifoCard()
                    
                    // 🔥 QUICK ACTIONS
                    QuickActions()
                    
                    // 🔥 LIVE / TODAY MATCHES
                    MatchesSection(title: "Live & Today")
                    
                    // 🔥 UPCOMING MATCHES
                    MatchesSection(title: "Next Matches")
                    
                    // 🔥 NEWS SECTION
                    NewsSection()
                    
                    // 🔥 QUICK STATS
                    QuickStatsSection()
                }
                .padding()
            }
            .navigationTitle("TifoFan")
        }
    }
}

// MARK: - TIFO CARD

struct TifoCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            Image("tifo_placeholder")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .cornerRadius(16)
            
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

// MARK: - QUICK ACTIONS

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

// MARK: - MATCHES SECTION

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

// MARK: - NEWS SECTION

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


#Preview {
    DashboardScreen()
}

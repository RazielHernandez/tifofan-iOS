//
//  LeagueDetailScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

enum LeagueTab: String, CaseIterable {
    case teams = "Teams"
    case standings = "Standings"
    case fixtures = "Fixtures"
    case stats = "Stats"
    case news = "News"
}

struct LeagueDetailView: View {
    
    let league: League
    
    @State private var selectedTab: LeagueTab = .teams
    
    var body: some View {
        VStack {
            
            // HEADER
            VStack(spacing: 12) {
                AsyncImage(url: league.logo) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 80, height: 80)
                
                Text(league.name)
                    .font(.title2)
                    .bold()
                
                Text(league.country)
                    .foregroundColor(.gray)
            }
            .padding()
            
            // TAB BAR
            HStack {
                ForEach(LeagueTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Text(tab.rawValue)
                            .font(.subheadline)
                            .foregroundColor(selectedTab == tab ? .white : .blue)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == tab ? Color.blue : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // CONTENT
            switch selectedTab {
            case .teams:
                TeamsView(league: league)
            case .standings:
                Text("Standings coming soon")
                Spacer()
            case .fixtures:
                Text("Fixtures coming soon")
                Spacer()
            case .stats:
                Text("Stats coming soon")
                Spacer()
            case .news:
                Text("News coming soon")
                Spacer()
            }
        }
        .navigationTitle(league.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

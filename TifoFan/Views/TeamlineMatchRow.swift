//
//  TeamLineMatchRow.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-17.
//

import SwiftUI

struct TimelineMatchRow: View {
    
    let match: Match
    let teamId: Int
    let isNext: Bool
    
    private var isHome: Bool {
        match.home.team.id == teamId
    }
    
    private var isPast: Bool {
        match.date < Date()
    }
    
    private var result: String? {
        guard
            let home = match.home.goals,
            let away = match.away.goals
        else { return nil }
        
        let teamGoals = isHome ? home : away
        let opponentGoals = isHome ? away : home
        
        if teamGoals > opponentGoals { return "W" }
        if teamGoals < opponentGoals { return "L" }
        return "D"
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            // 🧭 LEFT SIDE (DATE + TIMELINE)
            VStack(spacing: 6) {
                
                Text(match.date, format: .dateTime.weekday(.abbreviated).day().month())
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(match.displayStatus)
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                ZStack {
                    Circle()
                        .fill(markerColor)
                        .frame(width: 28, height: 28)
                    
                    Text(markerText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: 70)
            
            // 🏟️ MATCH CARD
            NavigationLink {
                MatchDetailScreen(matchId: match.id)
            } label: {
                HStack(spacing: 10) {
                    
                    AsyncImage(url: isHome ? match.away.team.logo : match.home.team.logo) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 30, height: 30)
                    
                    Text(isHome
                         ? "vs \(match.away.team.name)"
                         : "@ \(match.home.team.name)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    if let home = match.home.goals,
                       let away = match.away.goals {
                        
                        Text("\(home) - \(away)")
                            .fontWeight(.bold)
                    } else {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding()
                .background(cardBackground)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - UI Helpers
    
    private var markerText: String {
        if isNext { return "★" }
        return result ?? ""
    }
    
    private var markerColor: Color {
        if isNext { return .blue }
        
        switch result {
        case "W": return .green
        case "L": return .red
        case "D": return .gray
        default: return Color.gray.opacity(0.3)
        }
    }
    
    private var cardBackground: Color {
        if isNext {
            return Color.blue.opacity(0.12)
        } else if isPast {
            return Color(.systemBackground)
        } else {
            return Color.gray.opacity(0.05)
        }
    }
}

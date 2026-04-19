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
    
    @State private var animatePulse = false
    
    // MARK: - Match State
    
    private var isHome: Bool {
        match.home.team.id == teamId
    }
    
    private var isPast: Bool {
        match.date < Date()
    }
    
    private var isLive: Bool {
        ["1H", "2H", "HT", "ET", "P"].contains(match.status)
    }
    
    // MARK: - Result
    
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
    
    // MARK: - Status
    
    private var statusText: String {
        if isLive { return "LIVE" }
        return match.displayStatus
    }

    private var statusColor: Color {
        if isLive { return .red }
        return .gray
    }
    
    // MARK: - UI
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            timelineSection
            
            NavigationLink {
                MatchDetailScreen(matchId: match.id)
            } label: {
                matchCard
            }
        }
        .padding(.horizontal)
        .onAppear {
            if isLive {
                animatePulse = true
            }
        }
    }
    
    // MARK: - Timeline (Left)
    
    private var timelineSection: some View {
        VStack(spacing: 6) {
            
            Text(match.date, format: .dateTime.weekday(.abbreviated).day().month())
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(statusText)
                .font(.caption2)
                .fontWeight(isLive ? .bold : .regular)
                .foregroundColor(statusColor)
            
            ZStack {
                
                // 🔴 LIVE pulse
                if isLive {
                    Circle()
                        .stroke(Color.red.opacity(0.4), lineWidth: 3)
                        .frame(width: 34, height: 34)
                        .scaleEffect(animatePulse ? 1.4 : 1.0)
                        .opacity(animatePulse ? 0 : 1)
                        .animation(
                            .easeOut(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: animatePulse
                        )
                }
                
                Circle()
                    .fill(markerColor)
                    .frame(width: 28, height: 28)
                
                Text(markerText)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 2)
                .frame(maxHeight: .infinity)
        }
        .frame(width: 70)
    }
    
    // MARK: - Match Card
    
    private var matchCard: some View {
        HStack(spacing: 10) {
            
            AsyncImage(url: opponentLogo) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 30, height: 30)
            
            Text(opponentText)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            if isLive {
                liveBadge
            }
            
            scoreView
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.green)
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Components
    
    private var opponentLogo: URL? {
        isHome ? match.away.team.logo : match.home.team.logo
    }
    
    private var opponentText: String {
        isHome
        ? "vs \(match.away.team.name)"
        : "@ \(match.home.team.name)"
    }
    
    private var liveBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.red)
                .frame(width: 6, height: 6)
            
            Text("LIVE")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.red)
        }
    }
    
    private var scoreView: some View {
        Group {
            if let home = match.home.goals,
               let away = match.away.goals {
                
                Text("\(home) - \(away)")
                    .fontWeight(.bold)
                
            } else {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
            }
        }
    }
    
    // MARK: - Styling
    
    private var markerText: String {
        if isLive { return "●" }
        if isNext { return "★" }
        return result ?? ""
    }
    
    private var markerColor: Color {
        if isLive { return .red }
        if isNext { return .blue }
        
        switch result {
        case "W": return .green
        case "L": return .red
        case "D": return .gray
        default: return Color.gray.opacity(0.3)
        }
    }
    
    private var cardBackground: Color {
        if isLive {
            return Color.red.opacity(0.08)
        } else if isNext {
            return Color.blue.opacity(0.12)
        } else if isPast {
            return Color(.systemBackground)
        } else {
            return Color.gray.opacity(0.05)
        }
    }
}

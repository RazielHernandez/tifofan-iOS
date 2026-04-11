//
//  MatchRow.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-07.
//

import SwiftUI

struct MatchRow: View {
    
    let match: Match
    
    var body: some View {
        VStack(spacing: 10) {
            
            // 📅 DATE
            HStack {
                Text(formattedDate(match.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(match.displayStatus)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            // 🏟️ HOME
            HStack {
                HStack(spacing: 8) {
                    AsyncImage(url: match.home.team.logo) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 24, height: 24)
                    
                    Text(match.home.team.name)
                        .lineLimit(1)
                        .fontWeight(isWinner(home: true) ? .bold : .regular)
                }
                
                Spacer()
                
                if let goals = match.home.goals {
                    Text("\(goals)")
                        .fontWeight(isWinner(home: true) ? .bold : .regular)
                } else {
                    Text("-")
                        .foregroundColor(.secondary)
                }
            }
            
            // 🏟️ AWAY
            HStack {
                HStack(spacing: 8) {
                    AsyncImage(url: match.away.team.logo) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 24, height: 24)
                    
                    Text(match.away.team.name)
                        .lineLimit(1)
                        .fontWeight(isWinner(home: false) ? .bold : .regular)
                }
                
                Spacer()
                
                if let goals = match.away.goals {
                    Text("\(goals)")
                        .fontWeight(isWinner(home: false) ? .bold : .regular)
                } else {
                    Text("-")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func isWinner(home: Bool) -> Bool {
        guard
            let homeGoals = match.home.goals,
            let awayGoals = match.away.goals
        else {
            return false
        }
        
        return home
            ? homeGoals > awayGoals
            : awayGoals > homeGoals
    }
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, MMM d • HH:mm"
    return formatter.string(from: date)
}

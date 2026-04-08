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
            
            // 📅 DATE (TOP)
            HStack {
                Text(formattedDate(match.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(match.status ?? "")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            // 🏟️ TEAMS
            HStack {
                
                // HOME TEAM
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
                
                Text("\(match.home.goals)")
                    .fontWeight(isWinner(home: true) ? .bold : .regular)
            }
            
            HStack {
                
                // AWAY TEAM
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
                
                Text("\(match.away.goals)")
                    .fontWeight(isWinner(home: false) ? .bold : .regular)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func isWinner(home: Bool) -> Bool {
        if home {
            return match.home.goals > match.away.goals
        } else {
            return match.away.goals > match.home.goals
        }
    }
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, MMM d • HH:mm"
    return formatter.string(from: date)
}

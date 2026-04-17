//
//  EventRow.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-16.
//

import SwiftUI

struct EventRow: View {
    
    let event: MatchEvent
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            // ⏱️ TIME
            Text(event.time.display)
                .font(.caption)
                .frame(width: 50)
                .foregroundColor(.gray)
            
            // ⚽ ICON
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .frame(width: 20)
            
            // 📝 DETAILS
            VStack(alignment: .leading, spacing: 4) {
                
                Text(event.player.name ?? "Unknown")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if let assist = event.assist?.name {
                    Text("Assist: \(assist)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(event.detail)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

private extension EventRow {
    
    var iconName: String {
        switch event.type.lowercased() {
        case "goal":
            return "soccerball"
        case "card":
            return event.detail.lowercased().contains("red")
            ? "square.fill"
            : "rectangle.fill"
        case "subst":
            return "arrow.left.arrow.right"
        default:
            return "circle"
        }
    }
    
    var iconColor: Color {
        switch event.type.lowercased() {
        case "goal":
            return .green
        case "card":
            return event.detail.lowercased().contains("red") ? .red : .yellow
        case "subst":
            return .blue
        default:
            return .gray
        }
    }
}

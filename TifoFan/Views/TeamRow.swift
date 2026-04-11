//
//  TeamRow.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

struct TeamRow: View {
    
    let team: TeamSummary
    @Binding var isFavorite: Bool
    let onFavoriteTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: team.logo) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 40, height: 40)
            
            Text(team.name)
                .font(.headline)
            
            Spacer()
            
            Button(action: onFavoriteTap) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .scaleEffect(isFavorite ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3), value: isFavorite)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            isFavorite
            ? Color.red.opacity(0.05)
            : Color(.systemBackground)
        )
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

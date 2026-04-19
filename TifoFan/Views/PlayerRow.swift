//
//  PlayerRow.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-05.
//

import SwiftUI

struct PlayerRow: View {
    
    let player: TeamPlayer
    
    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: player.photo) { image in
                image.resizable()
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // 🧑 Name + position
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.headline)
                
                Text(player.position ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

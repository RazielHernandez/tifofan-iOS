//
//  TeamRow.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-04.
//

import SwiftUI

struct TeamRow: View {
    
    let team: TeamSummary
    
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
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

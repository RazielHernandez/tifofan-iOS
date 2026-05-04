//
//  TifoGeneratorScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-22.
//

import SwiftUI
import SwiftData

struct TifoGeneratorScreen: View {
    
    @EnvironmentObject var tifoVM: TifoViewModel
    let team: TeamSummary
    
    
    var body: some View {
        VStack(spacing: 16) {
            
            // 🔥 TITLE (Team Name)
            Text(team.name)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 🏟️ TIFO WITH STADIUM BACKGROUND
            ZStack {
                
                // Stadium background
                Image("TifoBackground")
                    .resizable()
                    .scaledToFill()
                    .overlay(Color.black.opacity(0.35))
                    .clipped()
                
                // Tifo
                TifoView(grid: tifoVM.tifosByTeam[team.id])
                    .padding(16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // 🎯 ACTION BAR
            HStack(spacing: 12) {
                
                ActionIconButton(title: "Generate", icon: "sparkles") {
                    Task {
                        await tifoVM.generateTifo(for: team)
                    }
                }
                
                ActionIconButton(title: "Edit", icon: "pencil") {
                    // TODO
                }
                
                ActionIconButton(title: "Share", icon: "square.and.arrow.up") {
                    // TODO
                }
                
                ActionIconButton(title: "Decorate", icon: "wand.and.stars") {
                    // TODO
                }
                
                ActionIconButton(title: "Delete", icon: "trash", isDestructive: true) {
                    Task {
                        try? await tifoVM.storageService?.deleteTifo(teamId: team.id)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .overlay {
            if tifoVM.isGenerating {
                ProgressView("Generating...")
            }
        }
        .onAppear {
            tifoVM.loadLocalTifo(teamId: team.id)
        }
    }
}

struct ActionIconButton: View {
    
    let title: String
    let icon: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.headline)
                    .frame(width: 40, height: 40)
                    .background(isDestructive ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

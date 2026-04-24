//
//  TifoGeneratorScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-22.
//

import SwiftUI
import SwiftData

struct TifoGeneratorScreen: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedTeam: TeamSummary?
    @StateObject private var tifoVM = TifoViewModel()
    @ObservedObject var favoritesVM: FavoritesViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Tifo Builder")
                .font(.largeTitle.bold())
            
            // MARK: - TEAM PICKER
            if favoritesVM.favoriteTeamIds.isEmpty {
                Spacer()
                Text("No favourite teams saved")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                
                Picker("Select Team", selection: $selectedTeam) {
                    ForEach(Array(favoritesVM.favoriteTeamIds), id: \.self) { teamId in
                        if let team = getTeam(teamId: teamId) {
                            HStack {
                                AsyncImage(url: team.logo) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 24, height: 24)
                                
                                Text(team.name)
                            }
                            .tag(Optional(team))
                        }
                    }
                }
                .pickerStyle(.menu)
            }
            
            // MARK: - TIFO PREVIEW
            TifoView(grid: tifoVM.generatedTifo)
                .frame(height: 200)
            
            // MARK: - ACTIONS
            VStack(spacing: 12) {
                
                Button("Generate Tifo from Logo") {
                    guard let team = selectedTeam else { return }
                    
                    Task {
                        await tifoVM.generateTifo(for: team)
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Edit Tifo") {}
                    .buttonStyle(.bordered)
                
                Button("Publish to Social Media") {}
                    .buttonStyle(.bordered)
                
                Button("Decorate Stadium") {}
                    .buttonStyle(.bordered)
                
                Button(role: .destructive) {
                    Task {
                        if let team = selectedTeam {
                            try? await tifoVM.storageService?.deleteTifo(teamId: team.id)
                            tifoVM.generatedTifo = nil
                        }
                    }
                } label: {
                    Text("Delete Tifo")
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
            tifoVM.setContext(context)
            
            Task {
                await favoritesVM.fetchFavorites()
                
                if selectedTeam == nil,
                   let firstId = favoritesVM.favoriteTeamIds.first {
                    selectedTeam = getTeam(teamId: firstId)
                }
            }
        }
        .onChange(of: selectedTeam) { team in
            guard let team else { return }
            
            tifoVM.loadLocalTifo(teamId: team.id)
        }
    }
    
//    var body: some View {
//        VStack(spacing: 0) {
//            
//            Text("Generate Tifo")
//                .font(.largeTitle.bold())
//                .padding(.top)
//            
//            if favoritesVM.favoriteTeamIds.isEmpty {
//                Spacer()
//                Text("No favorite teams yet")
//                    .foregroundColor(.secondary)
//                Spacer()
//            } else {
//                
//                List {
//                    ForEach(Array(favoritesVM.favoriteTeamIds), id: \.self) { teamId in
//                        
//                        Button {
//                            Task {
//                                if let team = getTeam(teamId: teamId) {
//                                    await tifoVM.generateTifo(for: team)
//                                }
//                            }
//                        } label: {
//                            HStack {
//                                Text("Team \(teamId)")
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .overlay {
//            if tifoVM.isGenerating {
//                ZStack {
//                    Color.black.opacity(0.4).ignoresSafeArea()
//                    ProgressView("Generating Tifo...")
//                        .padding()
//                        .background(.ultraThinMaterial)
//                        .cornerRadius(12)
//                }
//            }
//        }
//        .onAppear {
//            tifoVM.setContext(context)
//            
//            Task {
//                await favoritesVM.fetchFavorites()
//            }
//        }
//    }
    
    func getTeam(teamId: Int) -> TeamSummary? {
        return TeamSummary(
            id: teamId,
            name: "Team \(teamId)",
            logo: URL(string: "https://media.api-sports.io/football/teams/\(teamId).png")!
        )
    }
}

//struct TifoPreviewGrid: View {
//    
//    let grid: TifoGrid
//    
//    var columns: [GridItem] {
//        Array(repeating: GridItem(.flexible(), spacing: 1), count: grid.cols)
//    }
//    
//    var body: some View {
//        LazyVGrid(columns: columns, spacing: 1) {
//            ForEach(grid.cells.indices, id: \.self) { index in
//                Rectangle()
//                    .fill(Color(hex: grid.cells[index]))
//                    .aspectRatio(1, contentMode: .fit)
//            }
//        }
//        .background(Color.black)
//    }
//}

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

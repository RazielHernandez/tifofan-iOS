//
//  TifoViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-22.
//

import Foundation
import SwiftData
internal import Combine

@MainActor
final class TifoViewModel: ObservableObject {
    
    @Published var isGenerating = false
    @Published var errorMessage: String?
    @Published var generatedTifo: TifoGrid?
    
    private let generator = TifoGenerator()
    
    private var storage: TifoStorageService?
        
    func setContext(_ context: ModelContext) {
        self.storage = TifoStorageService(context: context)
    }
    
    func generateTifo(for team: TeamSummary) async {
        guard let logoURL = team.logo else {
            errorMessage = "Invalid logo URL"
            return
        }
        
        isGenerating = true
        errorMessage = nil
        
        do {
            // 1. Generate grid
            let grid = try await generator.generate(
                from: logoURL,
                rows: 40,
                cols: 40
            )
            
            // 2. Save locally + Firebase
            try await storage?.saveBaseTifo(
                grid: grid,
                teamId: team.id
            )
            
            generatedTifo = grid
            
        } catch {
            errorMessage = error.localizedDescription
            print("🔥 FULL ERROR:", error)
            
            if let nsError = error as NSError? {
                print("🔥 Code:", nsError.code)
                print("🔥 Domain:", nsError.domain)
                print("🔥 UserInfo:", nsError.userInfo)
            }
        }
        
        isGenerating = false
    }
}

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
        
        guard let storage else {
            errorMessage = "Storage not ready"
            return
        }
        
        guard let logoURL = team.logo else {
            errorMessage = "Invalid logo URL"
            return
        }
        
        errorMessage = nil
        
        do {
            print("🔍 Checking local tifo...")
            
            // ✅ STEP 1: Check local
            if let local = storage.getLocalTifo(teamId: team.id) {
                print("⚡ Found local tifo → loading instantly")
                
                generatedTifo = mapToGrid(local)
                isGenerating = false
                return
            }
            
            isGenerating = true
            
            print("🆕 No local tifo → generating...")
            
            // ✅ STEP 2: Generate
            let grid = try await generator.generate(
                from: logoURL,
                rows: 40,
                cols: 40
            )
            
            print("💾 Saving tifo...")
            
            // ✅ STEP 3: Save
            try await storage.saveBaseTifo(
                grid: grid,
                teamId: team.id
            )
            
            generatedTifo = grid
            
        } catch {
            print("❌ ERROR:", error)
            errorMessage = error.localizedDescription
        }
        
        isGenerating = false
    }
    
    func mapToGrid(_ local: LocalTifo) -> TifoGrid {
        return TifoGrid(
            rows: local.rows,
            cols: local.cols,
            cells: local.cells
        )
    }
    
    var storageService: TifoStorageService? {
        storage
    }
    
    func loadLocalTifo(teamId: Int) {
        
        guard let storage else { return }
        
        if let local = storage.getLocalTifo(teamId: teamId) {
            generatedTifo = TifoGrid(
                rows: local.rows,
                cols: local.cols,
                cells: local.cells
            )
        } else {
            generatedTifo = nil
        }
    }
    
//    func generateTifo(for team: TeamSummary) async {
//        guard let logoURL = team.logo else {
//            errorMessage = "Invalid logo URL"
//            return
//        }
//        
//        isGenerating = true
//        errorMessage = nil
//        
//        do {
//            // 1. Generate grid
//            let grid = try await generator.generate(
//                from: logoURL,
//                rows: 40,
//                cols: 40
//            )
//            
//            // 2. Save locally + Firebase
//            try await storage?.saveBaseTifo(
//                grid: grid,
//                teamId: team.id
//            )
//            
//            generatedTifo = grid
//            
//        } catch {
//            errorMessage = error.localizedDescription
//            print("🔥 FULL ERROR:", error)
//            
//            if let nsError = error as NSError? {
//                print("🔥 Code:", nsError.code)
//                print("🔥 Domain:", nsError.domain)
//                print("🔥 UserInfo:", nsError.userInfo)
//            }
//        }
//        
//        isGenerating = false
//    }
}

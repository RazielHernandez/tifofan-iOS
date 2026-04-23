//
//  TifoStorageService.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-22.
//

import Foundation
import SwiftUI
import SwiftData

final class TifoStorageService {
    
    private let db: LocalDatabase
        
    init(context: ModelContext) {
        self.db = LocalDatabase(context: context)
    }
    
    func saveBaseTifo(grid: TifoGrid, teamId: Int) async throws {
        
        let compressed = compressRLE(grid.cells)
        
        try await FirebaseService.shared.saveTifo(
            teamId: teamId,
            rows: grid.rows,
            cols: grid.cols,
            cells: compressed,
            type: "base"
        )
        
        let localTifo = LocalTifo(
            teamId: teamId,
            rows: grid.rows,
            cols: grid.cols,
            cells: grid.cells
        )
        
        try db.save(localTifo)
    }
    
    func compressRLE(_ cells: [String]) -> String {
        guard !cells.isEmpty else { return "" }
        
        var result: [String] = []
        var current = cells[0]
        var count = 1
        
        for i in 1..<cells.count {
            if cells[i] == current {
                count += 1
            } else {
                result.append("\(count):\(current)")
                current = cells[i]
                count = 1
            }
        }
        
        result.append("\(count):\(current)")
        
        return result.joined(separator: ",")
    }
}

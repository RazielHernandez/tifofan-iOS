//
//  Tifo.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-22.
//

import Foundation
import SwiftData
import SwiftUI

struct TifoGrid: Codable {
    let rows: Int
    let cols: Int
    let cells: [String]
}

@Model
final class LocalTifo {
    
    var id: UUID
    var teamId: Int
    var rows: Int
    var cols: Int
    var cells: [String]
    
    var createdAt: Date
    
    init(teamId: Int, rows: Int, cols: Int, cells: [String]) {
        self.id = UUID()
        self.teamId = teamId
        self.rows = rows
        self.cols = cols
        self.cells = cells
        self.createdAt = Date()
    }
}

extension LocalTifo {
    func toGrid() -> TifoGrid {
        TifoGrid(
            rows: rows,
            cols: cols,
            cells: cells
        )
    }
}

//extension TifoGrid {
//    
//    var dominantColor: Color {
//        let filtered = cells.filter { $0 != "clear" }
//
//        let counts = Dictionary(grouping: filtered, by: { $0 })
//            .mapValues { $0.count }
//        
//        let hex = counts.max(by: { $0.value < $1.value })?.key ?? "#222222"
//        return Color(hex: hex)
//    }
//}

extension TifoGrid {

    private var colorCounts: [(hex: String, count: Int)] {
        let filtered = cells.filter { $0 != "clear" }

        let counts = Dictionary(grouping: filtered, by: { $0 })
            .mapValues { $0.count }

        return counts
            .map { ($0.key, $0.value) }
            .sorted { $0.count > $1.count }
    }

    var dominantColor: Color {
        guard let first = colorCounts.first else {
            return .blue
        }
        return Color(hex: first.hex)
    }

    var secondaryColor: Color {
        guard colorCounts.count > 1 else {
            return dominantColor.opacity(0.7)
        }

        return Color(hex: colorCounts[1].hex)
    }
}

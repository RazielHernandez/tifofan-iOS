//
//  Match.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation

// MARK: - Match

struct Match: Codable, Identifiable, Equatable {
    let id: Int
    let leagueId: Int
    let season: Int
    let date: Date
    let status: String
    let home: MatchSide
    let away: MatchSide
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
    var displayStatus: String {
        switch status {
        case "FT": return "Finished"
        case "NS": return "Upcoming"
        case "PEN": return "Penalties"
        default: return status
        }
    }
}

struct MatchSide: Codable {
    let team: TeamSummary
    let goals: Int?
}

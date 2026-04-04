//
//  Match.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation

// MARK: - Match

struct Match: Codable, Identifiable {
    let id: Int
    let leagueId: Int
    let season: Int
    let date: Date
    let status: String
    let home: MatchSide
    let away: MatchSide
}

struct MatchSide: Codable {
    let team: TeamSummary
    let goals: Int
}

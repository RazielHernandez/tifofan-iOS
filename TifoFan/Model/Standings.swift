//
//  Standings.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-05.
//

import Foundation

struct StandingsRow: Codable, Identifiable {
    
    let rank: Int
    let team: TeamSummary
    let points: Int
    let goalsDiff: Int
    let form: String?
    let all: Stats
    
    var id: Int {team.id}
}

struct Stats: Codable {
    let played: Int
    let win: Int
    let draw: Int
    let lose: Int
    let goalsFor: Int
    let goalsAgainst: Int
}

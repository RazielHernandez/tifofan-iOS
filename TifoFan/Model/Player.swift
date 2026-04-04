//
//  Player.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-25.
//

import Foundation

struct Player: Codable, Identifiable {
    let id: Int
    let name: String
    let photo: URL?
    let age: Int
    let nationality: String
}

struct PlayerSeasonStats: Codable, Identifiable {
    
    var id: String { "\(leagueId)-\(season)" }

    let team: TeamSummary
    
    let leagueId: Int
    let leagueName: String
    let season: Int
    
    let appearances: Int
    let minutes: Int
    let position: String
    
    let rating: Double?
    
    let goals: Int
    let assists: Int
    
    let passes: Int
    let passAccuracy: Int?
    
    let yellowCards: Int
    let redCards: Int
}

struct PlayerAggregates: Codable {
    
    let appearances: Int
    let minutes: Int
    
    let goals: Int
    let assists: Int
    
    let yellowCards: Int
    let redCards: Int
    
    let averageRating: Double?
    
    let goalsPer90: Double
    let assistsPer90: Double
}

struct PlayerData: Codable {
    let player: Player
    let season: Int
    let stats: [PlayerSeasonStats]
    let aggregates: PlayerAggregates
    let cached: Bool
}

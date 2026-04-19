//
//  Team.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import Foundation

struct TeamSummary: Codable, Identifiable {
    let id: Int
    let name: String
    let logo: URL?
}

struct Team: Codable, Identifiable {
    let id: Int
    let name: String
    let logo: URL?
    let country: String?
}

struct TeamDetails: Codable {

    let team: TeamSummary
    
    let leagueId: Int
    let season: Int
    
    let stats: TeamSeasonStats
    let aggregates: TeamAggregates
}

struct TeamSeasonStats: Codable, Identifiable {
    
    var id: String { "\(leagueId)-\(season)" }
    
    let fixtures: TeamFixtures
    let form: String
    let goals: TeamGoals
    
    let leagueId: Int
    let season: Int
}

struct TeamFixtures: Codable {
    let played: Int
    let wins: Int
    let draws: Int
    let losses: Int
}

struct TeamGoals: Codable {
    let `for`: Int
    let against: Int
}

struct TeamAggregates: Codable {

    let matchesPlayed: Int

    let wins: Int
    let draws: Int
    let losses: Int

    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int

    let points: Int
    
    let winRate: FlexibleDouble
    let goalsForPerMatch: FlexibleDouble
    let goalsAgainstPerMatch: FlexibleDouble
}


// ========================= LINEUPS ===============================

struct TeamLineup: Codable, Identifiable {
    let id = UUID()
    
    let team: TeamWithColors
    let coach: Coach
    let formation: String
    let startXI: [LineupPlayer]
    let substitutes: [LineupPlayer]
}

struct TeamWithColors: Codable {
    let id: Int
    let name: String
    let logo: URL?
    let colors: TeamColors?
}

struct TeamColors: Codable {
    let player: ColorSet?
    let goalkeeper: ColorSet?
}

struct ColorSet: Codable {
    let primary: String?
    let number: String?
    let border: String?
}

struct Coach: Codable {
    let id: Int
    let name: String
    let photo: URL?
}

struct LineupPlayer: Codable, Identifiable {
    let id: Int
    let name: String
    let number: Int?
    let position: String?
    let grid: String?
}

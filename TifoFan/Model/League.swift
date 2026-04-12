//
//  league.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-21.
//

import Foundation

struct League: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String
    let countryCode: String
    let fromSeason: Int
    let logo: URL?
}

struct LeagueStats: Codable {
    let topScorers: [PlayerStat]
    let topAssists: [PlayerStat]
    let topCards: [PlayerStat]
    let teams: TeamStats
}

struct PlayerStat: Codable, Identifiable {
    let player: PlayerInfo
    let team: TeamInfo
    let statistics: PlayerStatistics
    
    var id: Int { player.id }
}

struct PlayerInfo: Codable {
    let id: Int
    let name: String
    let photo: URL
}

struct TeamInfo: Codable {
    let id: Int
    let name: String
    let logo: URL
}

struct PlayerStatistics: Codable {
    let goals: Int
    let assists: Int
    let appearances: Int
    let yellow: Int
    let red: Int
}

struct TeamStats: Codable {
    let bestAttack: TeamGoalStat
    let bestDefense: TeamGoalStat
    let topScoringTeams: [TeamGoalStat]
}

struct TeamGoalStat: Codable, Identifiable {
    let id: Int
    let name: String
    let logo: URL
    
    let goals: Int?
    let goalsAgainst: Int?
}

//
//  league.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-21.
//

import Foundation

//struct League: Codable, Identifiable {
//    let id: Int
//    let name: String
//    let country: String
//    let countryCode: String
//    let fromSeason: Int
//    let logo: URL?
//}
struct League: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String
    let countryCode: String
    let logo: URL?
    let seasons: [Season]
}

extension League {
    
    var currentSeason: Int {
        seasons.first(where: { $0.current })?.year
        ?? seasons.last?.year
        ?? 2025
    }
    
    var availableSeasons: [Int] {
        seasons.map { $0.year }.sorted(by: >)
    }
}

struct LeagueFavorite: Codable {
    let id: Int
    let name: String
    let country: String?
    let logo: String?
}

struct Season: Codable, Identifiable {
    var id: Int { year }
    
    let year: Int
    let start: String
    let end: String
    let current: Bool
    let coverage: Coverage
}

struct Coverage: Codable {
    let fixtures: FixtureCoverage
    let standings: Bool
    let players: Bool
    let topScorers: Bool
    let topAssists: Bool
    let topCards: Bool
    let injuries: Bool
    let predictions: Bool
    let odds: Bool
    
    enum CodingKeys: String, CodingKey {
        case fixtures, standings, players, injuries, predictions, odds
        case topScorers = "top_scorers"
        case topAssists = "top_assists"
        case topCards = "top_cards"
    }
}

struct FixtureCoverage: Codable {
    let events: Bool
    let lineups: Bool
    let statisticsFixtures: Bool
    let statisticsPlayers: Bool
    
    enum CodingKeys: String, CodingKey {
        case events, lineups
        case statisticsFixtures = "statistics_fixtures"
        case statisticsPlayers = "statistics_players"
    }
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

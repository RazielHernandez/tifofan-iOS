//
//  Team.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

//
//  Team.swift
//  TifoFan
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

//struct TeamAggregates: Codable {
//
//    let matchesPlayed: Int
//    
//    let wins: Int
//    let draws: Int
//    let losses: Int
//    
//    let goalsFor: Int
//    let goalsAgainst: Int
//    let goalDifference: Int
//    
//    let points: Int
//    let winRate: Int
//    
//    let goalsForPerMatch: Double?
//    let goalsAgainstPerMatch: Double?
//}

//struct TeamAggregates: Codable {
//
//    let matchesPlayed: Int
//    
//    let wins: Int
//    let draws: Int
//    let losses: Int
//    
//    let goalsFor: Int
//    let goalsAgainst: Int
//    let goalDifference: Int
//    
//    let points: Int
//    let winRate: Double?
//    
//    let goalsForPerMatch: Double?
//    let goalsAgainstPerMatch: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case matchesPlayed, wins, draws, losses
//        case goalsFor, goalsAgainst, goalDifference
//        case points
//        case winRate, goalsForPerMatch, goalsAgainstPerMatch
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        matchesPlayed = try container.decode(Int.self, forKey: .matchesPlayed)
//        wins = try container.decode(Int.self, forKey: .wins)
//        draws = try container.decode(Int.self, forKey: .draws)
//        losses = try container.decode(Int.self, forKey: .losses)
//        goalsFor = try container.decode(Int.self, forKey: .goalsFor)
//        goalsAgainst = try container.decode(Int.self, forKey: .goalsAgainst)
//        goalDifference = try container.decode(Int.self, forKey: .goalDifference)
//        points = try container.decode(Int.self, forKey: .points)
//
//        winRate = Self.decodeDouble(from: container, key: .winRate)
//        goalsForPerMatch = Self.decodeDouble(from: container, key: .goalsForPerMatch)
//        goalsAgainstPerMatch = Self.decodeDouble(from: container, key: .goalsAgainstPerMatch)
//    }
//}
//
//extension TeamAggregates {
//    
//    static func decodeDouble(
//        from container: KeyedDecodingContainer<CodingKeys>,
//        key: CodingKeys
//    ) -> Double? {
//        
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        
//        if let string = try? container.decode(String.self, forKey: key) {
//            return Double(string)
//        }
//        
//        return nil
//    }
//}

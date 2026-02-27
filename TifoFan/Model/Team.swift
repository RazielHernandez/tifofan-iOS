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

struct TeamResponse: Codable {
    let team: Team
    let cached: Bool
}

struct Team: Codable, Identifiable {
    let id: Int
    let name: String
    let logo: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, logo, country
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        logo = try? container.decode(String.self, forKey: .logo)
        
        if let countryString = try? container.decode(String.self, forKey: .country),
           countryString != "<null>" {
            country = countryString
        } else {
            country = nil
        }
    }
}

struct TeamDetailsResponse: Codable {
    let team: TeamCore
    let leagueId: Int
    let season: Int
    let stats: TeamSeasonStats
    let aggregates: TeamAggregates
    let cached: Bool
}

struct TeamCore: Codable, Identifiable {
    let id: Int
    let name: String
    let logo: String?
    let country: String?
}

struct TeamSeasonStats: Codable, Identifiable {
    
    var id: String { "\(leagueId)-\(season)" }
    
    let fixtures: TeamFixtures
    let form: String
    let goals: TeamGoals
    let leagueId: Int
    let season: Int
    let team: TeamCore
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
    let winRate: Int
    
    let goalsForPerMatch: Double?
    let goalsAgainstPerMatch: Double?
    
    enum CodingKeys: String, CodingKey {
        case matchesPlayed, wins, draws, losses
        case goalsFor, goalsAgainst, goalDifference
        case points, winRate
        case goalsForPerMatch, goalsAgainstPerMatch
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        matchesPlayed = try container.decode(Int.self, forKey: .matchesPlayed)
        wins = try container.decode(Int.self, forKey: .wins)
        draws = try container.decode(Int.self, forKey: .draws)
        losses = try container.decode(Int.self, forKey: .losses)
        
        goalsFor = try container.decode(Int.self, forKey: .goalsFor)
        goalsAgainst = try container.decode(Int.self, forKey: .goalsAgainst)
        goalDifference = try container.decode(Int.self, forKey: .goalDifference)
        
        points = try container.decode(Int.self, forKey: .points)
        winRate = try container.decode(Int.self, forKey: .winRate)
        
        if let gfString = try? container.decode(String.self, forKey: .goalsForPerMatch),
           let gf = Double(gfString) {
            goalsForPerMatch = gf
        } else {
            goalsForPerMatch = nil
        }
        
        if let gaString = try? container.decode(String.self, forKey: .goalsAgainstPerMatch),
           let ga = Double(gaString) {
            goalsAgainstPerMatch = ga
        } else {
            goalsAgainstPerMatch = nil
        }
    }
}

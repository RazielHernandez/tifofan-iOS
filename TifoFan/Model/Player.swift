//
//  Player.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-25.
//

import Foundation

struct PlayerResponse: Codable {
    let player: Player
    let season: Int
    let stats: [PlayerSeasonStats]
    let aggregates: PlayerAggregates
    let cached: Bool
}

struct Player: Codable, Identifiable {
    let id: Int
    let name: String
    let photo: String
    let age: Int
    let nationality: String
}

struct PlayerTeam: Codable {
    let id: Int
    let name: String
    let logo: String
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, logo, country
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        logo = try container.decode(String.self, forKey: .logo)
        
        if let countryString = try? container.decode(String.self, forKey: .country),
           countryString != "<null>" {
            country = countryString
        } else {
            country = nil
        }
    }
}

struct PlayerSeasonStats: Codable, Identifiable {
    
    var id: String { "\(leagueId)-\(season)" }
    
    let team: PlayerTeam
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
    
    enum CodingKeys: String, CodingKey {
        case team, leagueId, leagueName, season
        case appearances, minutes, position
        case rating, goals, assists
        case passes, passAccuracy
        case yellowCards, redCards
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        team = try container.decode(PlayerTeam.self, forKey: .team)
        leagueId = try container.decode(Int.self, forKey: .leagueId)
        leagueName = try container.decode(String.self, forKey: .leagueName)
        season = try container.decode(Int.self, forKey: .season)
        appearances = try container.decode(Int.self, forKey: .appearances)
        minutes = try container.decode(Int.self, forKey: .minutes)
        position = try container.decode(String.self, forKey: .position)
        goals = try container.decode(Int.self, forKey: .goals)
        assists = try container.decode(Int.self, forKey: .assists)
        passes = try container.decode(Int.self, forKey: .passes)
        yellowCards = try container.decode(Int.self, forKey: .yellowCards)
        redCards = try container.decode(Int.self, forKey: .redCards)
        
        // rating comes as "6.6" or "<null>"
        if let ratingString = try? container.decode(String.self, forKey: .rating),
           let ratingValue = Double(ratingString) {
            rating = ratingValue
        } else {
            rating = nil
        }
        
        // passAccuracy comes as "<null>"
        if let passString = try? container.decode(String.self, forKey: .passAccuracy),
           let passValue = Int(passString) {
            passAccuracy = passValue
        } else {
            passAccuracy = nil
        }
    }
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
    
    enum CodingKeys: String, CodingKey {
        case appearances, minutes, goals, assists
        case yellowCards, redCards
        case averageRating, goalsPer90, assistsPer90
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        appearances = try container.decode(Int.self, forKey: .appearances)
        minutes = try container.decode(Int.self, forKey: .minutes)
        goals = try container.decode(Int.self, forKey: .goals)
        assists = try container.decode(Int.self, forKey: .assists)
        yellowCards = try container.decode(Int.self, forKey: .yellowCards)
        redCards = try container.decode(Int.self, forKey: .redCards)
        goalsPer90 = try container.decode(Double.self, forKey: .goalsPer90)
        assistsPer90 = try container.decode(Double.self, forKey: .assistsPer90)
        
        if let ratingString = try? container.decode(String.self, forKey: .averageRating),
           let rating = Double(ratingString) {
            averageRating = rating
        } else {
            averageRating = nil
        }
    }
}

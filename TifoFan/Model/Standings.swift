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
    let home: BasicStats
    let away: BasicStats
    
    var id: Int { team.id }
    
    enum CodingKeys: String, CodingKey {
        case rank, team, points, goalsDiff, form
        case all, home, away
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        rank = try container.decode(Int.self, forKey: .rank)
        team = try container.decode(TeamSummary.self, forKey: .team)
        points = try container.decode(Int.self, forKey: .points)
        form = try container.decodeIfPresent(String.self, forKey: .form)
        
        all = try container.decode(Stats.self, forKey: .all)
        home = try container.decode(BasicStats.self, forKey: .home)
        away = try container.decode(BasicStats.self, forKey: .away)
        
        // Handle Int or String
        if let intVal = try? container.decode(Int.self, forKey: .goalsDiff) {
            goalsDiff = intVal
        } else if let strVal = try? container.decode(String.self, forKey: .goalsDiff) {
            goalsDiff = Int(strVal) ?? 0
        } else {
            goalsDiff = 0
        }
    }
}

struct BasicStats: Codable {
    let played: FlexibleInt
    let win: FlexibleInt
    let draw: FlexibleInt
    let lose: FlexibleInt
}

struct Stats: Codable {
    let played: FlexibleInt
    let win: FlexibleInt
    let draw: FlexibleInt
    let lose: FlexibleInt
    let goalsFor: FlexibleInt
    let goalsAgainst: FlexibleInt
}

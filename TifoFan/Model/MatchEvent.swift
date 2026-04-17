//
//  MatchEvent.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-16.
//

import Foundation

struct MatchEventsData: Codable {
    let match: MatchEventMatch
    let events: [MatchEvent]
}

struct MatchEventMatch: Codable, Identifiable {
    let id: Int
    let date: Date
    let status: String
    let venue: String?
    let league: LeagueSummary
    
    let home: EventTeamSide
    let away: EventTeamSide
}

struct EventTeamSide: Codable {
    let id: Int
    let name: String
    let logo: URL?
    let goals: Int?
}

struct LeagueSummary: Codable {
    let id: Int
    let name: String
    let logo: URL?
}

struct MatchEvent: Codable, Identifiable {
    
    let id = UUID()
    
    let time: EventTime
    let team: TeamSummary
    let player: EventPlayer
    let assist: EventPlayer?
    
    let type: String
    let detail: String
    let comments: String?
}

struct EventTime: Codable {
    let elapsed: Int?
    let extra: Int?
    
    var display: String {
        guard let elapsed = elapsed else { return "-" }
        if let extra = extra {
            return "\(elapsed)+\(extra)'"
        }
        return "\(elapsed)'"
    }
}

struct EventPlayer: Codable {
    let id: Int?
    let name: String?
}

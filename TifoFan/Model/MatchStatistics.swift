//
//  MatchStatitics.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation

// MARK: - Match Statistics Response

struct MatchStatisticsResponse: Codable {
    let data: [TeamMatchStatistics]
    let meta: SimpleMeta
}

struct TeamMatchStatistics: Codable {
    let team: TeamSummary
    let stats: MatchStatistics
}

struct MatchStatistics: Codable {
    let shotsOnGoal: Int?
    let shotsOffGoal: Int?
    let totalShots: Int?
    let fouls: Int?
    let corners: Int?
    let offsides: Int?
    let possession: Int?
    let yellowCards: Int?
    let redCards: Int?
    let passes: Int?
    let passAccuracy: Int?
}

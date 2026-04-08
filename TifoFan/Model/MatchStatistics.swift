//
//  MatchStatitics.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation

// MARK: - Match Statistics Response

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
    let yellowCards: FlexibleInt?
    let redCards: FlexibleInt?
    let passes: Int?
    let passAccuracy: Int?
}

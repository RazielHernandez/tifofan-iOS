//
//  MatchDetail.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation

// MARK: - Match Detail Response

struct MatchDetailResponse: Codable {
    let data: MatchDetail
    let meta: SimpleMeta
}

struct MatchDetail: Codable, Identifiable {
    let id: Int
    let leagueId: Int
    let season: Int
    let date: Date
    let status: String
    let home: MatchSide
    let away: MatchSide
    
    let venue: String?
    let referee: String?
    let halftimeScore: String?
    let fulltimeScore: String?
}

struct SimpleMeta: Codable {
    let timestamp: Int
    let cached: Bool
}

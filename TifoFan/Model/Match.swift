//
//  Match.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation

// MARK: - Matches List Response

struct MatchesResponse: Codable {
    let items: [Match]
    let pagination: Pagination
    let cached: Bool
}

// MARK: - Match

struct Match: Codable, Identifiable {
    let id: Int
    let leagueId: Int
    let season: Int
    let date: Date
    let status: String
    let home: MatchSide
    let away: MatchSide
}

// MARK: - Shared Models

struct MatchSide: Codable {
    let team: TeamSummary
    let goals: Int
}

struct TeamSummary: Codable {
    let id: Int
    let name: String
    let logo: String
}

// MARK: - Meta

struct Meta: Codable {
    let timestamp: Int
    let cached: Bool
    let pagination: Pagination?
}

struct Pagination: Codable {
    let page: Int
    let perPage: Int
    let totalItems: Int
    let totalPages: Int
    let hasNext: Bool
}

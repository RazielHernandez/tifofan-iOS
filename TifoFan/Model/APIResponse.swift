//
//  APIResponse.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-03-08.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let data: T
    let pagination: Pagination?
    let meta: Meta
}

struct Pagination: Codable {
    let page: Int
    let perPage: Int
    let totalItems: Int
    let totalPages: Int
    let hasNext: Bool
}

struct Meta: Codable {
    let timestamp: Int
    let cached: Bool
}

// MARK: - Teams

typealias TeamResponse = APIResponse<TeamSummary>
typealias TeamsInLeagueResponse = APIResponse<[TeamSummary]>
typealias TeamDetailsResponse = APIResponse<TeamDetails>
typealias TeamPlayersResponse = APIResponse<[TeamPlayer]>

// MARK: - Matches

typealias MatchesResponse = APIResponse<[Match]>
typealias MatchDetailResponse = APIResponse<MatchDetail>
typealias MatchStatisticsResponse = APIResponse<[TeamMatchStatistics]>

// MARK: - Players

typealias PlayerResponse = APIResponse<PlayerData>

// MARK: - Leagues

typealias SupportedLeaguesResponse = APIResponse<[League]>

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
typealias MatchLineupResponse = APIResponse<[TeamLineup]>

// MARK: - Players

typealias PlayerResponse = APIResponse<PlayerData>

// MARK: - Leagues

typealias SupportedLeaguesResponse = APIResponse<[League]>
typealias LeagueStatsResponse = APIResponse<LeagueStats>

// MARK: - Favourites
typealias FavoritesResponse = APIResponse<FavoritesData>

struct FlexibleDouble: Codable {
    let value: Double?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = Double(string)
        } else {
            value = nil
        }
    }
}


extension FlexibleDouble {
    
    func formatted(_ decimals: Int = 1) -> String {
        guard let value = value else { return "-" }
        return String(format: "%.\(decimals)f", value)
    }
    
    func percentage(_ decimals: Int = 1) -> String {
        guard let value = value else { return "-" }
        return String(format: "%.\(decimals)f%%", value)
    }
}

struct FlexibleInt: Codable {
    let value: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let int = try? container.decode(Int.self) {
            value = int
        } else if let string = try? container.decode(String.self),
                  string != "<null>" {
            value = Int(string)
        } else {
            value = nil
        }
    }
}

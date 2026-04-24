//
//  FirebaseService.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-21.
//

import Foundation
import FirebaseFunctions

import Foundation
import FirebaseFunctions

final class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let functions = Functions.functions(region: "us-central1")
    
    private init() {}
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // MARK: - Generic Callable Handler
    
    private func callFunction<T: Decodable>(
        name: String,
        data: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        let result = try await functions
            .httpsCallable(name)
            .call(data)
        
        print("🔥 RAW RESULT:", result.data)
        
        let payload: Any
        
        // Handles Firebase callable wrapper
        if let dict = result.data as? [String: Any],
           let inner = dict["result"] {
            payload = inner
        } else {
            payload = result.data
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        
        return try decoder.decode(T.self, from: jsonData)
    }
}

extension FirebaseService {
    
    func getTeam(teamId: Int) async throws -> TeamResponse {
        try await callFunction(
            name: "v1-getTeamCallable",
            data: ["id": teamId],
            responseType: TeamResponse.self
        )
    }
    
    func getTeamDetails(
        teamId: Int,
        leagueId: Int,
        season: Int
    ) async throws -> TeamDetailsResponse {
        try await callFunction(
            name: "v1-getTeamDetailsCallable",
            data: [
                "team": teamId,
                "league": leagueId,
                "season": season
            ],
            responseType: TeamDetailsResponse.self
        )
    }
    
    func getTeamPlayers(
        teamId: Int,
        leagueId: Int,
        season: Int,
        page: Int = 1
    ) async throws -> TeamPlayersResponse {
        try await callFunction(
            name: "v1-getTeamPlayersCallable",
            data: [
                "team": teamId,
                "league": leagueId,
                "season": season,
                "page": page
            ],
            responseType: TeamPlayersResponse.self
        )
    }
}

extension FirebaseService {
    
    func getSupportedLeagues() async throws -> SupportedLeaguesResponse {
        try await callFunction(
            name: "v1-getSupportedLeaguesCallable",
            responseType: SupportedLeaguesResponse.self
        )
    }
    
    func getTeamsByLeague(
        league: Int,
        season: Int,
    ) async throws -> TeamsInLeagueResponse {
        try await callFunction(
            name: "v1-getTeamsByLeagueCallable",
            data: [
                "league": league,
                "season": season,
            ],
            responseType: TeamsInLeagueResponse.self
        )
    }
    
    func getLeagueStandings(
        league: Int,
        season: Int
    ) async throws -> APIResponse<[StandingsRow]> {
        try await callFunction(
            name: "v1-getLeagueStandingsCallable",
            data: [
                "league": league,
                "season": season
            ],
            responseType: APIResponse<[StandingsRow]>.self
        )
    }
    
    func getLeagueStats(
        league: Int,
        season: Int
    ) async throws -> LeagueStatsResponse {
        
        try await callFunction(
            name: "v1-getLeagueStatsCallable",
            data: [
                "league": league,
                "season": season
            ],
            responseType: LeagueStatsResponse.self
        )
    }
}

extension FirebaseService {
    
    func getPlayer(
        playerId: Int,
        season: Int
    ) async throws -> PlayerResponse {
        try await callFunction(
            name: "v1-getPlayerCallable",
            data: [
                "id": playerId,
                "season": season
            ],
            responseType: PlayerResponse.self
        )
    }
}

extension FirebaseService {
    
    func getMatches(
        leagueId: Int,
        season: Int,
        page: Int = 1
    ) async throws -> MatchesResponse {
        try await callFunction(
            name: "v1-getMatchesCallable",
            data: [
                "league": leagueId,
                "season": season,
                "page": page
            ],
            responseType: MatchesResponse.self
        )
    }
    
    func getMatchDetail(
        matchId: Int
    ) async throws -> MatchDetailResponse {
        try await callFunction(
            name: "v1-getMatchDetailsCallable",
            data: ["fixture": matchId],
            responseType: MatchDetailResponse.self
        )
    }
    
    func getMatchStatistics(
        matchId: Int
    ) async throws -> MatchStatisticsResponse {
        try await callFunction(
            name: "v1-getMatchStatisticsCallable",
            data: ["fixture": matchId],
            responseType: MatchStatisticsResponse.self
        )
    }
    
    func getMatchLineups(
        matchId: Int
    ) async throws -> MatchLineupResponse {
        try await callFunction(
            name: "v1-getMatchLineupsCallable",
            data: ["fixture": matchId],
            responseType: MatchLineupResponse.self
        )
    }
    
    func getMatchesByTeam(
        teamId: Int,
        season: Int
    ) async throws -> MatchesResponse {
        try await callFunction(
            name: "v1-getMatchesByTeamCallable",
            data: [
                "team": teamId,
                "season": season
            ],
            responseType: MatchesResponse.self
        )
    }
    
    func getMatchesByRound(
        leagueId: Int,
        season: Int,
        round: String
    ) async throws -> MatchesResponse {
        
        try await callFunction(
            name: "v1-getMatchesByRoundCallable",
            data: [
                "league": leagueId,
                "season": season,
                "round": round
            ],
            responseType: MatchesResponse.self
        )
    }
    
    func getMatchesByDate(
        date: Date
    ) async throws -> MatchesResponse {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let dateString = formatter.string(from: date)
        
        return try await callFunction(
            name: "v1-getMatchesByDateCallable",
            data: [
                "date": dateString
            ],
            responseType: MatchesResponse.self
        )
    }
    
    func getMatchEvents(
        matchId: Int
    ) async throws -> MatchEventsResponse {
        try await callFunction(
            name: "v1-getMatchEventsCallable",
            data: [
                "fixture": matchId
            ],
            responseType: MatchEventsResponse.self
        )
    }
}

extension FirebaseService {
    
    // MARK: - Favorites
    
    func getFavorites() async throws -> FavoritesResponse {
        try await callFunction(
            name: "v1-getFavorites",
            responseType: FavoritesResponse.self
        )
    }
    
    func addFavorite(
        type: String,
        item: Encodable
    ) async throws -> APIResponse<SuccessResponse> {
        
        try await callFunction(
            name: "v1-addFavorite",
            data: [
                "type": type,
                "item": item.toDictionary()
            ],
            responseType: APIResponse<SuccessResponse>.self
        )
    }
    
    func removeFavorite(
        type: String,
        id: Int
    ) async throws -> APIResponse<SuccessResponse> {
        
        try await callFunction(
            name: "v1-removeFavorite",
            data: [
                "type": type,
                "id": id
            ],
            responseType: APIResponse<SuccessResponse>.self
        )
    }
    
    func saveFavorites(
        leagues: [League],
        teams: [TeamSummary]
    ) async throws -> APIResponse<SuccessResponse> {
        
        try await callFunction(
            name: "v1-saveFavorites",
            data: [
                "leagues": leagues.map { $0.toDictionary() },
                "teams": teams.map { $0.toDictionary() }
            ],
            responseType: APIResponse<SuccessResponse>.self
        )
    }
}

// MARK: - TIFO

extension FirebaseService {
    
    func saveTifo(
        teamId: Int,
        rows: Int,
        cols: Int,
        cells: String,
        type: String = "base"
    ) async throws -> APIResponse<SuccessResponse> {
        
        try await callFunction(
            name: "v1-saveTifo",
            data: [
                "teamId": teamId,
                "rows": rows,
                "cols": cols,
                "cells": cells,
                "type": type
            ],
            responseType: APIResponse<SuccessResponse>.self
        )
    }
    
    func deleteTifo(teamId: Int) async throws {
        _ = try await callFunction(
            name: "v1-deleteTifo",
            data: ["teamId": teamId],
            responseType: APIResponse<SuccessResponse>.self
        )
    }
}

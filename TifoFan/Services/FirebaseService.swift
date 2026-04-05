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
}


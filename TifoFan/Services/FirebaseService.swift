//
//  FirebaseService.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-21.
//

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
    
    // Generic callable handler (Firebase wrapper aware)
    private func callFunction<T: Decodable>(
        name: String,
        data: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        let result = try await functions
            .httpsCallable(name)
            .call(data)
        
        let payload: Any
        
        print("🔥 RAW RESULT:", result.data)
        
        if let dict = result.data as? [String: Any],
           let inner = dict["result"] {
            payload = inner
        } else {
            // If Firebase already returns raw array/object
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
            data: [
                "id": teamId
            ],
            responseType: TeamResponse.self
        )
        /*let callable = functions.httpsCallable("v1-getTeamCallable")
        
        let result = try await callable.call([
            "id": teamId
        ])
        
        guard let data = result.data as? [String: Any] else {
            throw NSError(domain: "DecodingError", code: -1)
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        
        return try JSONDecoder().decode(TeamResponse.self, from: jsonData)*/
        
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
            
            /*let callable = functions.httpsCallable("v1-getTeamDetailsCallable")
            
            let result = try await callable.call([
                "team": teamId,
                "league": leagueId,
                "season": season
            ])
            
            guard let data = result.data as? [String: Any] else {
                throw NSError(domain: "DecodingError", code: -1)
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            
            return try JSONDecoder().decode(
                TeamDetailsResponse.self,
                from: jsonData
            )*/
        }
}

extension FirebaseService {
    
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
        
        /*let callable = functions.httpsCallable("v1-getTeamPlayersCallable")
        
        let result = try await callable.call([
            "team": teamId,
            "league": leagueId,
            "season": season,
            "page": page
        ])
        
        guard let data = result.data as? [String: Any] else {
            throw NSError(domain: "DecodingError", code: -1)
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        
        return try JSONDecoder().decode(
            TeamPlayersResponse.self,
            from: jsonData
        )*/
    }
}

extension FirebaseService {
    
    func getSupportedLeagues() async throws -> [League] {
        try await callFunction(
            name: "v1-getSupportedLeaguesCallable",
            responseType: [League].self
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

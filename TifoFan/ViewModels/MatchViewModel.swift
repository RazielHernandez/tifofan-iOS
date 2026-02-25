//
//  MatchViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation
internal import Combine

@MainActor
final class MatchViewModel: ObservableObject {
    
    @Published var matches: [Match] = []
    @Published var selectedMatch: MatchDetail?
    @Published var statistics: [TeamMatchStatistics] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = FirebaseService.shared
    
    // MARK: - Fetch Matches
    func fetchMatches(leagueId: Int, season: Int, page: Int = 1) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.getMatches(
                leagueId: leagueId,
                season: season,
                page: page
            )
            
            matches = response.items
        } catch {
            errorMessage = error.localizedDescription
            print("🔥 FULL ERROR:", error)
            
            if let nsError = error as NSError? {
                print("🔥 Code:", nsError.code)
                print("🔥 Domain:", nsError.domain)
                print("🔥 UserInfo:", nsError.userInfo)
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Match Detail
    func fetchMatchDetail(matchId: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.getMatchDetail(matchId: matchId)
            selectedMatch = response.data
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Statistics
    
    func fetchMatchStatistics(matchId: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.getMatchStatistics(matchId: matchId)
            statistics = response.data
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

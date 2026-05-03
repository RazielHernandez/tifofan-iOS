//
//  MatchViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation
import SwiftUI
internal import Combine

enum MatchFilter {
    case league
    case team
    case date
    case round
}

@MainActor
final class MatchViewModel: ObservableObject {
    
    @Published var matches: [Match] = []
    @Published var selectedMatch: MatchDetail?
    @Published var statistics: [TeamMatchStatistics] = []
    @Published var currentFilter: MatchFilter = .league
    
    @Published var matchesByTeam: [Int: [Match]] = [:]
    @Published var nextMatches: [Int: Match] = [:]
    
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
            
            withAnimation(.easeInOut) {
                matches = response.data
            }
            
            currentFilter = .league
        } catch {
            handleError(error, functionName: "fetchMatches")
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
            
            if response.data.status != "NS" {
                await fetchMatchStatistics(matchId: matchId)
            } else {
                statistics = []
            }
            
        } catch {
            handleError(error, functionName: "fetchMatchDetail")
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
            handleError(error, functionName: "fetchMatchStatistics")
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Matches by Team
    
    func fetchMatchesByTeam(teamId: Int, season: Int) async {
            isLoading = true
            errorMessage = nil
            
            do {
                let response = try await service.getMatchesByTeam(
                    teamId: teamId,
                    season: season
                )
                
                let sorted = response.data.sorted { $0.date < $1.date }
                let now = Date()
                
                // ✅ Compute next match ONCE
                let next = sorted.first { $0.date >= now }
                
                withAnimation(.easeInOut) {
                    matchesByTeam[teamId] = sorted
                    nextMatches[teamId] = next
                }
                
                currentFilter = .team
                
            } catch {
                handleError(error, functionName: "fetchMatchesByTeam")
            }
            
            isLoading = false
        }
    
    // MARK: - fetch Matches by date (one day)
    
    func fetchMatchesByDate(
        date: Date
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.getMatchesByDate(date: date)
            
            withAnimation(.easeInOut) {
                matches = response.data.sorted { $0.date < $1.date }
            }
            
            currentFilter = .date
        } catch {
            handleError(error, functionName: "fetchMatchesByDate")
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Matches by round
    
    func fetchMatchesByRound(
        leagueId: Int,
        season: Int,
        round: String
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.getMatchesByRound(
                leagueId: leagueId,
                season: season,
                round: round
            )
            
            withAnimation(.easeInOut) {
                matches = response.data.sorted { $0.date < $1.date }
            }
            
            currentFilter = .round
        } catch {
            handleError(error, functionName: "Matches by Round")
        }
        
        isLoading = false
    }
    
    // MARK: - Helpers for Dashboard

    func nextMatch(for leagueId: Int) -> Match? {
        let now = Date()
        
        return matches
            .sorted { $0.date < $1.date }
            .first { $0.date >= now }
    }

    func nextMatch(forTeam teamId: Int) -> Match? {
        let now = Date()
        
        return matches
            .filter {
                $0.home.team.id == teamId ||
                $0.away.team.id == teamId
            }
            .sorted { $0.date < $1.date }
            .first { $0.date >= now }
    }
    
    // MARK: - Assign adn print the error (debugging)
    
    private func handleError(_ error: Error, functionName: String) {
        errorMessage = error.localizedDescription
        
        print("🔥 [\(functionName)] Error:")
        print("🔥 FULL ERROR:", error)
        
        if let nsError = error as NSError? {
            print("🔥 Code:", nsError.code)
            print("🔥 Domain:", nsError.domain)
            print("🔥 UserInfo:", nsError.userInfo)
        }
    }
}

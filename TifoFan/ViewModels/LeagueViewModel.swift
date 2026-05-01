//
//  LeagueViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-21.
//

import Foundation
internal import Combine

@MainActor
final class LeagueViewModel: ObservableObject {
    
    @Published var leagues: [League] = []
    @Published var teams: [TeamSummary] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchLeagues() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await FirebaseService.shared.getSupportedLeagues()
            
            leagues = response.data
        } catch {
            print("🔥 FULL ERROR:", error)
            errorMessage = error.localizedDescription
            
            if let nsError = error as NSError? {
                print("🔥 Code:", nsError.code)
                print("🔥 Domain:", nsError.domain)
                print("🔥 UserInfo:", nsError.userInfo)
            }
        }
        
        isLoading = false
    }
    
    func currentSeason(for leagueId: Int) -> Int {
        leagues.first(where: { $0.id == leagueId })?.currentSeason ?? 2025
    }
    
    func fetchLeaguesWithTeams(league: Int, season: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await FirebaseService.shared.getTeamsByLeague(league: league, season: season)
            
            teams = response.data
        } catch {
            print("🔥 LEAGUES VIEW MODEL ERROR:", error)
            errorMessage = error.localizedDescription
            
            if let nsError = error as NSError? {
                print("🔥 Code:", nsError.code)
                print("🔥 Domain:", nsError.domain)
                print("🔥 UserInfo:", nsError.userInfo)
            }
        }
        
        isLoading = false
    }
}

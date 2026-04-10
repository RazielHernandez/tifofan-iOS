//
//  FavouritesViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-09.
//

import Foundation
internal import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published var favoriteLeagueIds: Set<Int> = []
    @Published var favoriteTeamIds: Set<Int> = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Fetch
    
    func fetchFavorites() async {
        do {
            let response = try await FirebaseService.shared.getFavorites()
            
            let leagues = response.data.leagues
            let teams = response.data.teams
            
            favoriteLeagueIds = Set(leagues.map { $0.id })
            favoriteTeamIds = Set(teams.map { $0.id })
            
        } catch {
            print("🔥 FULL ERROR:", error)
            errorMessage = error.localizedDescription
            
            if let nsError = error as NSError? {
                print("🔥 Code:", nsError.code)
                print("🔥 Domain:", nsError.domain)
                print("🔥 UserInfo:", nsError.userInfo)
            }
        }
    }
    
    // MARK: - Add
    
    func addFavoriteLeague(_ league: League) async {
            
        // Optimistic update
        favoriteLeagueIds.insert(league.id)
        
        do {
            try await FirebaseService.shared.addFavorite(
                type: "league",
                item: league
            )
        } catch {
            print("❌ Add league failed:", error)
            
            // Rollback if failed
            favoriteLeagueIds.remove(league.id)
        }
    }
    
    func addFavoriteTeam(_ team: TeamSummary) async {
        
        favoriteTeamIds.insert(team.id)
        
        do {
            try await FirebaseService.shared.addFavorite(
                type: "team",
                item: team
            )
        } catch {
            print("❌ Add team failed:", error)
            favoriteTeamIds.remove(team.id)
        }
    }
    
    // MARK: - Remove Favorite
    
    func removeFavoriteLeague(_ leagueId: Int) async {
        
        // Optimistic update
        favoriteLeagueIds.remove(leagueId)
        
        do {
            try await FirebaseService.shared.removeFavorite(
                type: "league",
                id: leagueId
            )
        } catch {
            print("❌ Remove league failed:", error)
            
            // Rollback
            favoriteLeagueIds.insert(leagueId)
        }
    }
    
    func removeFavoriteTeam(_ teamId: Int) async {
        
        favoriteTeamIds.remove(teamId)
        
        do {
            try await FirebaseService.shared.removeFavorite(
                type: "team",
                id: teamId
            )
        } catch {
            print("❌ Remove team failed:", error)
            favoriteTeamIds.insert(teamId)
        }
    }
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data),
              let dict = json as? [String: Any] else {
            return [:]
        }
        return dict
    }
}

extension FavoritesViewModel {
    
    func toggleLeague(_ league: League) async {
        if favoriteLeagueIds.contains(league.id) {
            await removeFavoriteLeague(league.id)
        } else {
            await addFavoriteLeague(league)
        }
    }
    
    func toggleTeam(_ team: TeamSummary) async {
        if favoriteTeamIds.contains(team.id) {
            await removeFavoriteTeam(team.id)
        } else {
            await addFavoriteTeam(team)
        }
    }
}

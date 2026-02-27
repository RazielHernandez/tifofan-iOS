//
//  TeamPlayersViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import Foundation
internal import Combine

@MainActor
final class TeamPlayersViewModel: ObservableObject {
    
    @Published var players: [TeamPlayer] = []
    @Published var pagination: Pagination?
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var currentPage = 1
    private var hasNext = true
    
    func fetchFirstPage(
        teamId: Int,
        leagueId: Int,
        season: Int
    ) async {
        currentPage = 1
        players.removeAll()
        hasNext = true
        
        await fetchPage(
            teamId: teamId,
            leagueId: leagueId,
            season: season
        )
    }
    
    func fetchNextPage(
        teamId: Int,
        leagueId: Int,
        season: Int
    ) async {
        guard hasNext, !isLoading else { return }
        
        currentPage += 1
        
        await fetchPage(
            teamId: teamId,
            leagueId: leagueId,
            season: season
        )
    }
    
    private func fetchPage(
        teamId: Int,
        leagueId: Int,
        season: Int
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await FirebaseService.shared
                .getTeamPlayers(
                    teamId: teamId,
                    leagueId: leagueId,
                    season: season,
                    page: currentPage
                )
            
            players.append(contentsOf: response.items)
            pagination = response.pagination
            hasNext = response.pagination.hasNext
            
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
}

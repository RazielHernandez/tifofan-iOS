//
//  TeamDetailsViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import Foundation
internal import Combine

@MainActor
final class TeamDetailsViewModel: ObservableObject {
    
    @Published var response: TeamDetailsResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchTeamDetails(
        teamId: Int,
        leagueId: Int,
        season: Int
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            response = try await FirebaseService.shared
                .getTeamDetails(
                    teamId: teamId,
                    leagueId: leagueId,
                    season: season
                )
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

//
//  StandingsViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-05.
//

import Foundation
internal import Combine

@MainActor
final class StandingsViewModel: ObservableObject {
    
    @Published var standings: [StandingsRow] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchStandings(league: Int, season: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await FirebaseService.shared.getLeagueStandings(
                league: league,
                season: season
            )
            
            standings = response.data
            
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
}

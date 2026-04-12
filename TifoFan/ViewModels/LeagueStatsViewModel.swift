//
//  LeagueStatsViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-12.
//

import Foundation
internal import Combine

@MainActor
final class LeagueStatsViewModel: ObservableObject {
    
    @Published var stats: LeagueStats?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = FirebaseService.shared
    
    func fetchStats(league: Int, season: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.getLeagueStats(
                league: league,
                season: season
            )
            
            stats = response.data
            
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        
        print("🔥 FULL ERROR:", error)
        
        if let nsError = error as NSError? {
            print("🔥 Code:", nsError.code)
            print("🔥 Domain:", nsError.domain)
            print("🔥 UserInfo:", nsError.userInfo)
        }
    }
}

//
//  LineupViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-08.
//

import Foundation
internal import Combine

@MainActor
class LineupViewModel: ObservableObject {
    
    @Published var lineups: [TeamLineup] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = FirebaseService.shared
    
    func fetchLineups(matchId: Int) async {
        isLoading = true
        
        do {
            let response = try await service.getMatchLineups(matchId: matchId)
            
            lineups = response.data
            
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

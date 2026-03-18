//
//  PlayerViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-25.
//

import Foundation
internal import Combine

@MainActor
final class PlayerViewModel: ObservableObject {
    
    @Published var data: PlayerData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchPlayer(playerId: Int, season: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await FirebaseService.shared
                .getPlayer(playerId: playerId, season: season)
            
            data = response.data
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

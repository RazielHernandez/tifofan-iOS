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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchLeagues() async {
        isLoading = true
        errorMessage = nil
        
        do {
            leagues = try await FirebaseService.shared.getSupportedLeagues()
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

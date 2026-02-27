//
//  TeamViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import Foundation
internal import Combine

@MainActor
final class TeamViewModel: ObservableObject {
    
    @Published var response: TeamResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchTeam(teamId: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            response = try await FirebaseService.shared
                .getTeam(teamId: teamId)
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

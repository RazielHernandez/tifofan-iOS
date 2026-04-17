//
//  EventsViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-16.
//

import Foundation
internal import Combine

@MainActor
final class MatchEventsViewModel: ObservableObject {
    
    @Published var events: [MatchEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = FirebaseService.shared
    
    func fetchEvents(matchId: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.getMatchEvents(matchId: matchId)
            events = response.data.events.sorted {
                ($0.time.elapsed ?? 0) < ($1.time.elapsed ?? 0)
            }
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

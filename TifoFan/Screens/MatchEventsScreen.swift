//
//  MatchEventsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-16.
//

import SwiftUI

struct MatchEventsScreen: View {
    
    let matchId: Int
    @StateObject private var vm = MatchEventsViewModel()
    
    var body: some View {
        ScrollView {
            
            if vm.isLoading {
                ProgressView().padding()
                
            } else if let error = vm.errorMessage {
                Text(error)
                
            } else {
                
                VStack(spacing: 12) {
                    ForEach(vm.events) { event in
                        EventRow(event: event)
                    }
                }
                .padding()
            }
        }
        .task {
            await vm.fetchEvents(matchId: matchId)
        }
    }
}

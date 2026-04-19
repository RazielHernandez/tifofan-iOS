//
//  MatchEventsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-16.
//

import SwiftUI

struct MatchEventsScreen: View {
    
    let matchId: Int
    let match: MatchDetail   // 👈 NEW
    
    @StateObject private var vm = MatchEventsViewModel()
    
    var body: some View {
        ScrollView {
            
            if vm.isLoading {
                
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading match events...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                
            } else if let error = vm.errorMessage {
                
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text("Something went wrong")
                        .font(.headline)
                    
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                
            } else if vm.events.isEmpty {
                
                MatchEmptyState(
                    icon: "clock",
                    title: "No events yet",
                    subtitle: "Live events will appear here during the match."
                )
                
            } else {
                
                timelineView
            }
        }
        .task {
            await vm.fetchEvents(matchId: matchId)
        }
    }
    
//    private var emptyState: some View {
//        
//        VStack(spacing: 16) {
//            
//            Image(systemName: iconName)
//                .font(.largeTitle)
//                .foregroundColor(.gray)
//            
//            Text(titleText)
//                .font(.headline)
//            
//            Text(subtitleText)
//                .font(.caption)
//                .foregroundColor(.secondary)
//        }
//        .padding(.top, 40)
//    }
    
    private var iconName: String {
        match.status == "NS" ? "clock" : "bolt.horizontal"
    }

    private var titleText: String {
        switch match.status {
        case "NS": return "Match not started"
        case "FT": return "No events recorded"
        default: return "No events yet"
        }
    }

    private var subtitleText: String {
        switch match.status {
        case "NS":
            return "Live events will appear here once the match begins."
        case "FT":
            return "This match had no major events."
        default:
            return "Events will update as the match progresses."
        }
    }
    
    private var timelineView: some View {
        
        VStack(spacing: 20) {
            
            ForEach(vm.events) { event in
                EventRow(event: event)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.vertical)
    }
}

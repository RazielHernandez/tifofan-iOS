//
//  Untitled.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-29.
//

import Foundation
internal import Combine

@MainActor
final class TeamStatsViewModel: ObservableObject {

    @Published var statsByTeam: [Int: TeamDetails] = [:]
    @Published var isLoading = false

    func fetch(
        teamId: Int,
        leagueId: Int,
        season: Int
    ) async {

        if statsByTeam[teamId] != nil { return }

        isLoading = true

        do {
            let response = try await FirebaseService.shared.getTeamDetails(
                teamId: teamId,
                leagueId: leagueId,
                season: season
            )

            statsByTeam[teamId] = response.data

        } catch {
            print("🔥 stats error:", error)
        }

        isLoading = false
    }
}

//
//  Favourites.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-09.
//

import Foundation

struct SuccessResponse: Codable {
    let success: Bool
}

struct FavoritesData: Codable {
    let leagues: [League]
    let teams: [TeamSummary]
}

//
//  TeamPlayer.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import Foundation

struct TeamPlayersResponse: Codable {
    let items: [TeamPlayer]
    let pagination: Pagination
    let cached: Bool
}

struct TeamPlayer: Codable, Identifiable {
    let id: Int
    let name: String
    let age: Int?
    let position: String?
    let photo: String?
}

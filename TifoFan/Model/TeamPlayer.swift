//
//  TeamPlayer.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-26.
//

import Foundation

struct TeamPlayer: Codable, Identifiable {
    let id: Int
    let name: String
    let age: Int?
    let position: String?
    let photo: URL?
}

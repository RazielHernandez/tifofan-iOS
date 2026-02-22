//
//  league.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-21.
//

struct League: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String
    let countryCode: String
    let fromSeason: Int
    let logo: String
}

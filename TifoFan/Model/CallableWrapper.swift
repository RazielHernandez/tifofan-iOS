//
//  CallableWrapper.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-24.
//

import Foundation

struct CallableWrapper<T: Codable>: Codable {
    let result: T
}

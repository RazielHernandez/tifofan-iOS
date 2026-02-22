//
//  FirebaseService.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-21.
//

import Foundation
import FirebaseFunctions

final class FirebaseService {
    
    static let shared = FirebaseService()
    
    private let functions = Functions.functions(region: "us-central1")
    
    private init() {}
    
    // Generic callable handler
    private func callFunction<T: Decodable>(
        name: String,
        data: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        let result = try await functions
            .httpsCallable(name)
            .call(data)
        
        let jsonData = try JSONSerialization.data(withJSONObject: result.data)
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
}

extension FirebaseService {
    
    func getSupportedLeagues() async throws -> [League] {
        try await callFunction(
            name: "v1-getSupportedLeaguesCallable",
            responseType: [League].self
        )
    }
}

//
//  LocalDatabase.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-04-22.
//

import SwiftData
import Foundation

@MainActor
final class LocalDatabase {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ tifo: LocalTifo) throws {
        context.insert(tifo)
        try context.save()
    }
    
    func fetchTifo(teamId: Int) throws -> LocalTifo? {
        let descriptor = FetchDescriptor<LocalTifo>(
            predicate: #Predicate<LocalTifo> { $0.teamId == teamId }
        )
        
        return try context.fetch(descriptor).first
    }
    
    func exists(teamId: Int) throws -> Bool {
        try fetchTifo(teamId: teamId) != nil
    }
}

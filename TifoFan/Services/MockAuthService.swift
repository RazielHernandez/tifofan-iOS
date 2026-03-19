//
//  MockAuthService.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-03-19.
//

import Foundation

final class MockAuthService: AuthServiceProtocol {
    
    var currentUser: AppUser? = nil
    
    func signIn(email: String, password: String) async throws {
        currentUser = AppUser(id: "123", email: email)
    }
    
    func signUp(email: String, password: String) async throws {
        currentUser = AppUser(id: "123", email: email)
    }
    
    func signOut() throws {
        currentUser = nil
    }
    
    func resetPassword(email: String) async throws {}
}

//
//  AuthService.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-03-18.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    var currentUser: AppUser? { get }
    
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signOut() throws
    func resetPassword(email: String) async throws
}

final class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    
    private init() {}
    
    var currentUser: AppUser? {
        guard let user = Auth.auth().currentUser else { return nil }
        
        return AppUser(
            id: user.uid,
            email: user.email
        )
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        
        print("✅ Signed in:", result.user.uid)
    }
    
    func signUp(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        
        print("✅ User created:", result.user.uid)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

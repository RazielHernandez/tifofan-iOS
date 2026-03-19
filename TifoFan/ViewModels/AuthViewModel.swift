//
//  AuthViewModel.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-03-18.
//

import Foundation
internal import Combine
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    
    // MARK: - State
    @Published var user: AppUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var infoMessage: String?
    
    // MARK: - Form Fields
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    private let service: AuthServiceProtocol
    
    // MARK: - Init
    init(service: AuthServiceProtocol) {
        self.service = service
        self.user = service.currentUser
    }
    
    // MARK: - Computed
    
    var isLoggedIn: Bool {
        user != nil
    }
    
    var isLoginValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var isSignupValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }
    
    // MARK: - Actions
    func signIn() async {
        await execute {
            try await self.service.signIn(email: self.email, password: self.password)
            self.user = self.service.currentUser
        }
    }
    
    func signUp() async {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        await execute {
            try await self.service.signUp(email: self.email, password: self.password)
            self.user = self.service.currentUser
        }
    }
    
    func signOut() {
        do {
            try service.signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func resetPassword() async {
        guard !email.isEmpty else {
            errorMessage = "Enter your email first"
            return
        }
        
        await execute {
            try await self.service.resetPassword(email: self.email)
            self.infoMessage = "Password reset email sent"
        }
    }
    
    // MARK: - Helper
    
    private func execute(_ block: @escaping () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        infoMessage = nil
        
        do {
            try await block()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

extension AuthViewModel {
    static var previewSignup: AuthViewModel {
        let vm = AuthViewModel(service: MockAuthService())
        vm.email = "test@email.com"
        vm.password = "123456"
        vm.confirmPassword = "123456"
        return vm
    }
}

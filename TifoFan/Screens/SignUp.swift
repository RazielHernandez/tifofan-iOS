//
//  SignUp.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-19.
//

import SwiftUI

struct SignUpScreen: View {
    
    @EnvironmentObject var vm: AuthViewModel
    var onSwitch: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                
                Text("Sign Up")
                    .font(.title)
                    .bold()
                
                TextField("Email", text: $vm.email)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $vm.password)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Confirm Password", text: $vm.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    Task { await vm.signUp() }
                } label: {
                    if vm.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(vm.isSignupValid ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(!vm.isSignupValid)
                
                HStack {
                    Text("Already have an account?")
                    Button("Sign In") {
                        onSwitch()
                    }
                }
                .font(.footnote)
                
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview("Sign Up - Default") {
    SignUpScreen(onSwitch: {})
        .environmentObject(AuthViewModel(service: MockAuthService()))
}

#Preview("Sign Up - Valid") {
    let vm = AuthViewModel(service: MockAuthService())
    vm.email = "test@email.com"
    vm.password = "123456"
    vm.confirmPassword = "123456"
    
    return SignUpScreen(onSwitch: {})
        .environmentObject(vm)
}

#Preview("Sign Up - Error") {
    let vm = AuthViewModel(service: MockAuthService())
    vm.errorMessage = "Email already in use"
    
    return SignUpScreen(onSwitch: {})
        .environmentObject(vm)
}

#Preview("Sign Up - Loading") {
    let vm = AuthViewModel(service: MockAuthService())
    vm.isLoading = true
    
    return SignUpScreen(onSwitch: {})
        .environmentObject(vm)
}

#Preview("Sign Up - Invalid") {
    let vm = AuthViewModel(service: MockAuthService())
    vm.email = "test@email.com"
    vm.password = "123"
    vm.confirmPassword = "456"
    
    return SignUpScreen(onSwitch: {})
        .environmentObject(vm)
}



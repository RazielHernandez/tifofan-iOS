//
//  Sig.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-19.
//

import SwiftUI

struct SignInScreen: View {
    
    @EnvironmentObject var vm: AuthViewModel
    var onSwitch: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                
                Text("Sign In")
                    .font(.title)
                    .bold()
                
                TextField("Email", text: $vm.email)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $vm.password)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Spacer()
                    Button("Forgot Password?") {
                        Task { await vm.resetPassword() }
                    }
                    .font(.footnote)
                }
                
                Button {
                    Task { await vm.signIn() }
                } label: {
                    if vm.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(vm.isLoginValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(!vm.isLoginValid)
                
                Button("Continue with Google") {
                    // TODO
                }
                
                HStack {
                    Text("Don't have an account?")
                    Button("Sign Up") {
                        onSwitch()
                    }
                }
                .font(.footnote)
                
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                if let info = vm.infoMessage {
                    Text(info)
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview("Sign In - Default") {
    SignInScreen(onSwitch: {})
        .environmentObject(AuthViewModel(service: MockAuthService()))
}


#Preview("Sign In - Error") {
    let vm = AuthViewModel(service: MockAuthService())
    vm.errorMessage = "Invalid email or password"
    
    return SignInScreen(onSwitch: {})
        .environmentObject(vm)
}

#Preview("Sign In - Loading") {
    let vm = AuthViewModel(service: MockAuthService())
    vm.isLoading = true
    
    return SignInScreen(onSwitch: {})
        .environmentObject(vm)
}

#Preview("Sign In - Filled") {
    let vm = AuthViewModel(service: MockAuthService())
    vm.email = "test@email.com"
    vm.password = "123456"
    
    return SignInScreen(onSwitch: {})
        .environmentObject(vm)
}

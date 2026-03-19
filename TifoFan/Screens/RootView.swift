//
//  RootView.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-03-18.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var vm = AuthViewModel(service: AuthService.shared)
    
    var body: some View {
        Group {
            if vm.isLoggedIn {
                ContentView()
            } else {
                AuthContainerView()
                    .environmentObject(vm)
            }
        }
    }
}

struct AuthContainerView: View {
    
    @EnvironmentObject var vm: AuthViewModel
    @State private var isLogin = true
    
    var body: some View {
        ZStack {
            Image("SampleBackgroundB")
            
            if isLogin {
                SignInScreen(
                    onSwitch: { isLogin = false }
                )
            } else {
                SignUpScreen(
                    onSwitch: { isLogin = true }
                )
            }
        }
    }
}

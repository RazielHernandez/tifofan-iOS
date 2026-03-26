//
//  SettingsScreen.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-16.
//

import SwiftUI

struct SettingsScreen: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var notificationsEnabled = true
    @State private var showVersionSheet = false
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var showClearCacheAlert = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - General
                
                Section("General") {
                    
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    
                    SettingsRow(
                        icon: "moon.fill",
                        title: "Dark Mode",
                        subtitle: "System Default"
                    )
                    
                    SettingsRow(
                        icon: "star.fill",
                        title: "Favorite Team"
                    )
                }
                
                // MARK: - Data
                
                Section("Data") {
                    
                    Button {
                        showClearCacheAlert = true
                    } label: {
                        Label("Clear Cache", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                    
                    Button {
                        
                        // TODO: REFRESH API DATA
                        print("Refresh data")
                        
                    } label: {
                        Label("Refresh Data", systemImage: "arrow.clockwise")
                    }
                }
                
                // MARK: - About
                
                Section("About") {
                    
                    Button {
                        showVersionSheet = true
                    } label: {
                        HStack {
                            Label("App Version", systemImage: "info.circle")
                            Spacer()
                            Text(appVersion)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Button {
                        showTerms = true
                    } label: {
                        SettingsRow(
                            icon: "doc.text",
                            title: "Terms & Conditions"
                        )
                    }
                    
                    Button {
                        showPrivacy = true
                    } label: {
                        SettingsRow(
                            icon: "lock.shield",
                            title: "Privacy Policy"
                        )
                    }
                    
                }
                
                // MARK: - Account

                Section {
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
        // MARK: Sheets
        .sheet(isPresented: $showVersionSheet) {
            AboutSheet()
        }

        .sheet(isPresented: $showTerms) {
            TermsSheet()
        }

        .sheet(isPresented: $showPrivacy) {
            PrivacySheet()
        }
        .alert("Clear Cache?", isPresented: $showClearCacheAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                
                // TODO: CLEANING CACHE
                print("Cleaning cache")
                
            }
        } message: {
            Text("This will remove locally cached data.")
        }
        .alert("Log out?", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                authVM.signOut()
            }
        }
    }
    
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (\(build))"
    }
}

// MARK: Settings Row view
struct SettingsRow: View {
    
    var icon: String
    var title: String
    var subtitle: String? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading) {
                Text(title)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SettingsScreen()
}

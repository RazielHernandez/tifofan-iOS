//
//  TifoFanApp.swift
//  TifoFan
//
//  Created by Puma Azteca on 2026-02-04.
//

import SwiftUI
import FirebaseCore
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct TifoFanApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var favoritesVM = FavoritesViewModel()
    @StateObject private var tifosVM = TifoViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(favoritesVM)
                .environmentObject(tifosVM)
        }
        .modelContainer(for: [LocalTifo.self])
    }
}

//
//  MapApp.swift
//  MapApp
//
//  Created by OstapMamykin on 24.03.2026.
//

import SwiftUI
import FirebaseCore

@main
struct TravelMemorizeApp: App {
    @State private var router = AppCoordinator()
    @State private var languageStore = AppLanguageStore()
    @State private var authSession: AuthSessionStore

    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        _authSession = State(initialValue: AuthSessionStore())
    }
    
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(languageStore)
                .environment(authSession)
        }
        .environment(router)
    }
}

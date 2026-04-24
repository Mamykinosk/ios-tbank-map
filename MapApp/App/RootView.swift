//
//  RootView.swift
//  MapApp
//
//  Created by Иван Метальников on 10.04.2026.
//

import Foundation
import SwiftUI

struct RootView: View {
    @Environment(AppCoordinator.self) var router
    @Environment(AuthSessionStore.self) var authSession

    var body: some View {
        Group {
            if authSession.isAuthenticated {
                MainMapView()
            } else {
                AuthFlowView()
            }
        }
        .environment(router)
        .environment(authSession)
    }
}

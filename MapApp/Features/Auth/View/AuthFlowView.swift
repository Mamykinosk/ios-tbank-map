//
//  AuthFlowView.swift
//  MapApp
//
//  Created by Иван Метальников on 10.04.2026.
//
import SwiftUI


struct AuthFlowView: View {
    @Environment(AppCoordinator.self) var coordinator
    
    @State var authViewModel = AuthViewModel()

    var body: some View {
        @Bindable var coordinator = coordinator

        NavigationStack(path: $coordinator.authPath) {
            StartView()
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .login:
                        LoginView(authViewModel: authViewModel)
                    case .register:
                        RegisterView(authViewModel: authViewModel)
                    case .recovery:
                        RecoveryView(authViewModel: authViewModel)
                    }
                }
        }
    }
}

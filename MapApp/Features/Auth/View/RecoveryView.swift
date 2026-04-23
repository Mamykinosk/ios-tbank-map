import Foundation
import SwiftUI

struct RecoveryView: View {
    @Environment(AppCoordinator.self) var router
    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            contentCanvas
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            authViewModel.clearFeedback()
        }
    }

    private var contentCanvas: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    heroSection
                        .padding(.top, 12)

                    headerSection
                        .padding(.top, 48)

                    formSection
                        .padding(.top, 40)
                }
                .padding(.top, 16)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            Image("recovery_forest")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 192)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .clipped()

            LinearGradient(
                colors: [
                    Color.appBackground,
                    Color.appBackground.opacity(0),
                    Color.appBackground.opacity(0)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 192)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        }
        .frame(maxWidth: .infinity)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Auth.Recovery.resetPasswordTitle)
                .font(.system(size: 36, weight: .bold))
                .tracking(-0.9)
                .foregroundStyle(Color.appTitle)

            Text(L10n.Auth.Recovery.resetPasswordSubtitle)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.appSecondary.opacity(0.8))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.Auth.Common.emailTitle)
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appPrimary)
                    .padding(.leading, 4)

                VStack(alignment: .leading, spacing: 8) {
                    TextField(
                        "",
                        text: $authViewModel.email,
                        prompt: Text("hello@travelmemorize.com")
                            .foregroundStyle(Color.appPlaceholder)
                    )
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.appTitle)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                    .background(Color.appFieldBackground)
                    .overlay {
                        Capsule()
                            .stroke(Color.appPrimary.opacity(0.05), lineWidth: 1)
                    }
                    .clipShape(Capsule())

                    if let errorMessage = authViewModel.errorMessage {
                        AuthFeedbackBanner(message: errorMessage, tone: .error)
                    }

                    if let infoMessage = authViewModel.infoMessage {
                        AuthFeedbackBanner(message: infoMessage, tone: .success)
                    }
                }
            }

            VStack(spacing: 16) {
                Button {
                    authViewModel.sendPasswordReset()
                } label: {
                    HStack(spacing: 8) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(L10n.Auth.Recovery.sendResetLinkAction)
                                .font(.system(size: 16, weight: .semibold))
                            Image(systemName: "paperplane")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color.appPrimary, Color.appAccent],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.appPrimary.opacity(0.1), radius: 15, x: 0, y: 10)
                }
                .buttonStyle(.plain)
                .disabled(authViewModel.isLoading)

                Button {
                    router.showLogin()
                } label: {
                    Text(L10n.Auth.Recovery.backToSingIn)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.appSecondaryAction)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

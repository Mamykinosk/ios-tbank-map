import SwiftUI

struct RegisterView: View {
    @Environment(AppCoordinator.self) var router
    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            backgroundDecorations

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    brandSection
                        .padding(.bottom, 40)

                    formCard

                    footerSection
                        .padding(.top, 48)

                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 128)
                        .padding(.top, 64)
                }
                .frame(maxWidth: 400)
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            authViewModel.clearFeedback()
        }
    }

    private var backgroundDecorations: some View {
        ZStack {
            Ellipse()
                .fill(Color.registerGreenGlow.opacity(0.2))
                .frame(width: 234, height: 392)
                .blur(radius: 50)
                .offset(x: -120, y: -220)

            Ellipse()
                .fill(Color.registerBlueGlow.opacity(0.1))
                .frame(width: 195, height: 294)
                .blur(radius: 40)
                .offset(x: 150, y: 420)
        }
        .ignoresSafeArea()
    }

    private var brandSection: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color.appMuted)
                    .frame(width: 64, height: 64)

                Image(systemName: "leaf.fill")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
            }
            .padding(.bottom, 24)

            Text(L10n.Auth.Register.registerTitle)
                .font(.system(size: 36, weight: .bold))
                .tracking(-0.9)
                .foregroundStyle(Color.appTitle)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)

            Text(L10n.Auth.Register.registerSubtitle)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appSecondary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var formCard: some View {
        VStack(spacing: 20) {
            RegisterInputField(
                title: L10n.Auth.Register.usernameTitle,
                text: $authViewModel.username,
                placeholder: L10n.Auth.Register.usernamePlaceholder,
                systemImage: "person"
            )

            RegisterInputField(
                title: L10n.Auth.Common.emailTitle,
                text: $authViewModel.email,
                placeholder: LocalizedStringKey("hello@travelmemorize.com"),
                systemImage: "at"
            )

            RegisterSecureField(
                title: L10n.Auth.Common.passwordTitle,
                text: $authViewModel.password,
                placeholder: "••••••••",
                systemImage: "lock"
            )

            RegisterSecureField(
                title: L10n.Auth.Register.confirmPasswordTitle,
                text: $authViewModel.confirmPassword,
                placeholder: "••••••••",
                systemImage: "checkmark.shield"
            )

            if let errorMessage = authViewModel.errorMessage {
                AuthFeedbackBanner(message: errorMessage, tone: .error)
            }

            if let infoMessage = authViewModel.infoMessage {
                AuthFeedbackBanner(message: infoMessage, tone: .success)
            }

            Button { //
                authViewModel.registerUser()
            } label: {
                Group {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(L10n.Auth.Register.registerAction)
                            .font(.system(size: 16, weight: .semibold))
                            .tracking(0.4)
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
                .shadow(color: Color.appPrimary.opacity(0.1), radius: 15, x: 0, y: 8)
            }
            .buttonStyle(.plain)
            .disabled(authViewModel.isLoading)
        }
        .padding(.horizontal, 32)
        .padding(.top, 32)
        .padding(.bottom, 48)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 20, x: 0, y: 8)
    }

    private var footerSection: some View {
        HStack(spacing: 4) {
            Text(L10n.Auth.Register.alreadyHaveAccount)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.appSecondary)

            Button(L10n.Auth.Register.loginNow) {
                router.showLogin()
            }
            .buttonStyle(.plain)
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Color.appPrimary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct RegisterInputField: View {
    let title: LocalizedStringKey
    @Binding var text: String
    let placeholder: LocalizedStringKey
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .tracking(1.1)
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, 4)

            HStack(spacing: 12) {
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.appPlaceholder))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.appTitle)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appPlaceholder)
            }
            .padding(.horizontal, 20)
            .frame(height: 55)
            .background(Color.appFieldBackground)
        }
    }
}

private struct RegisterSecureField: View {
    let title: LocalizedStringKey
    @Binding var text: String
    let placeholder: LocalizedStringKey
    let systemImage: String

    @State private var isSecure = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .tracking(1.1)
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, 4)

            HStack(spacing: 12) {
                Group {
                    if isSecure {
                        SecureField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.appPlaceholder))
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.appPlaceholder))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.appTitle)

                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.appPlaceholder)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .frame(height: 55)
            .background(Color.appFieldBackground)
        }
    }
}

private extension Color {
    static let registerGreenGlow = Color.appGreenGlow
    static let registerBlueGlow = Color.appBlueGlow
}

#Preview {
    RegisterView(authViewModel: AuthViewModel())
}

import SwiftUI

struct LoginView: View {
    @Environment(AppCoordinator.self) var router
    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Circle()
                .fill(Color.loginGreenGlow.opacity(0.35))
                .frame(width: 234, height: 391)
                .blur(radius: 50)
                .offset(x: -120, y: -330)

            Circle()
                .fill(Color.loginBlueGlow.opacity(0.25))
                .frame(width: 195, height: 293)
                .blur(radius: 40)
                .offset(x: 145, y: 390)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(Color.appMuted)
                                .frame(width: 64, height: 64)

                            Image(systemName: "leaf.fill")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(Color.appPrimary)
                        }
                        .padding(.bottom, 24)

                        Text("Welcome Back")
                            .font(.system(size: 36, weight: .bold))
                            .kerning(-0.9)
                            .foregroundStyle(Color.appTitle)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)

                        Text("Continue your journey through memories")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.appSecondary.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 48)

                    VStack(alignment: .leading, spacing: 32) {
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("EMAIL")
                                    .font(.system(size: 11, weight: .bold))
                                    .kerning(1.1)
                                    .foregroundStyle(Color.appPrimary)
                                    .padding(.horizontal, 4)

                                ZStack(alignment: .trailing) {
                                    TextField("hello@travelmemorize.com", text: $authViewModel.email)
                                        .font(.system(size: 16, weight: .regular))
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.emailAddress)
                                        .autocorrectionDisabled(true)
                                        .padding(.horizontal, 20)
                                        .frame(height: 55)
                                        .background(Color.appFieldBackground)

                                    Image(systemName: "at")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.appPlaceholder)
                                        .padding(.trailing, 16)
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("PASSWORD")
                                        .font(.system(size: 11, weight: .bold))
                                        .kerning(1.1)
                                        .foregroundStyle(Color.appPrimary)

                                    Spacer()

                                    Button {
                                        router.goToRecovery()
                                    } label: {
                                        Text("FORGOT PASSWORD?")
                                            .font(.system(size: 11, weight: .bold))
                                            .kerning(0.55)
                                            .foregroundStyle(Color.appSecondaryAction)
                                    }
                                }
                                .padding(.horizontal, 4)

                                ZStack(alignment: .trailing) {
                                    SecureField("••••••••", text: $authViewModel.password)
                                        .font(.system(size: 16, weight: .regular))
                                        .padding(.horizontal, 20)
                                        .frame(height: 55)
                                        .background(Color.appFieldBackground)

                                    Image(systemName: "lock")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(Color.appPlaceholder)
                                        .padding(.trailing, 16)
                                }
                            }

                            if let errorMessage = authViewModel.errorMessage {
                                AuthFeedbackBanner(message: errorMessage, tone: .error)
                            }

                            if let infoMessage = authViewModel.infoMessage {
                                AuthFeedbackBanner(message: infoMessage, tone: .success)
                            }

                            Button {
                                authViewModel.loginUser()
                            } label: {
                                Group {
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Login")
                                            .font(.system(size: 16, weight: .semibold))
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
                                .shadow(color: Color.appPrimary.opacity(0.12), radius: 12, x: 0, y: 8)
                            }
                            .buttonStyle(.plain)
                            .disabled(authViewModel.isLoading)
                        }

                        ZStack {
                            Rectangle()
                                .fill(Color.appMuted.opacity(0.4))
                                .frame(height: 1)
                                .padding(.horizontal, 56)

                            Text("OR CONNECT WITH")
                                .font(.system(size: 10, weight: .bold))
                                .kerning(1)
                                .foregroundStyle(Color.appPlaceholder)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                        }
                        .frame(height: 15)

                        HStack(spacing: 16) {
                            socialButton(icon: "character.book.closed")
                            socialButton(icon: "globe")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(32)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .shadow(color: Color.black.opacity(0.04), radius: 20, x: 0, y: 8)

                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.appSecondary)

                        Button {
                            router.goToRegister()
                        } label: {
                            Text("Register now")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color.appPrimary)
                        }
                    }
                    .padding(.top, 20)

                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.6))
                        .frame(height: 128)
                        .padding(.top, 64)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .frame(maxWidth: 400)
            }
        }
        .onAppear {
            authViewModel.clearFeedback()
        }
    }

    private func socialButton(icon: String) -> some View {
        Button(action: {}) {
            ZStack {
                Circle()
                    .fill(Color.loginSocialBackground)
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.appSecondary)
            }
        }
        .buttonStyle(.plain)
        .disabled(authViewModel.isLoading)
    }
}

private extension Color {
    static let loginGreenGlow = Color.appGreenGlow
    static let loginBlueGlow = Color.appBlueGlow
    static let loginSocialBackground = Color(red: 240 / 255, green: 237 / 255, blue: 232 / 255)
}

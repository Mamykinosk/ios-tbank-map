import SwiftUI


struct LoginView: View {
    @Environment(AppRouter.self) var router
    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color(red: 252 / 255, green: 249 / 255, blue: 244 / 255)
                .ignoresSafeArea()

            Circle()
                .fill(Color(red: 194 / 255, green: 233 / 255, blue: 201 / 255).opacity(0.35))
                .frame(width: 234, height: 391)
                .blur(radius: 50)
                .offset(x: -120, y: -330)

            Circle()
                .fill(Color(red: 189 / 255, green: 233 / 255, blue: 255 / 255).opacity(0.25))
                .frame(width: 195, height: 293)
                .blur(radius: 40)
                .offset(x: 145, y: 390)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 229 / 255, green: 226 / 255, blue: 221 / 255))
                                .frame(width: 64, height: 64)

                            Image(systemName: "leaf.fill")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(Color(red: 22 / 255, green: 52 / 255, blue: 41 / 255))
                        }
                        .padding(.bottom, 24)

                        Text("Welcome Back")
                            .font(.system(size: 36, weight: .bold))
                            .kerning(-0.9)
                            .foregroundStyle(Color(red: 28 / 255, green: 28 / 255, blue: 25 / 255))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)

                        Text("Continue your journey through memories")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color(red: 65 / 255, green: 72 / 255, blue: 69 / 255).opacity(0.8))
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
                                    .foregroundStyle(Color(red: 22 / 255, green: 52 / 255, blue: 41 / 255))
                                    .padding(.horizontal, 4)

                                ZStack(alignment: .trailing) {
                                    TextField("hello@travelmemorize.com", text: $authViewModel.email)
                                        .font(.system(size: 16, weight: .regular))
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.emailAddress)
                                        .autocorrectionDisabled(true)
                                        .padding(.horizontal, 20)
                                        .frame(height: 55)
                                        .background(Color(red: 235 / 255, green: 232 / 255, blue: 227 / 255))

                                    Image(systemName: "at")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color(red: 168 / 255, green: 162 / 255, blue: 158 / 255))
                                        .padding(.trailing, 16)
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("PASSWORD")
                                        .font(.system(size: 11, weight: .bold))
                                        .kerning(1.1)
                                        .foregroundStyle(Color(red: 22 / 255, green: 52 / 255, blue: 41 / 255))

                                    Spacer()

                                    Button(action: {
                                        router.goToRecovery()
                                    }) {
                                        Text("FORGOT PASSWORD?")
                                            .font(.system(size: 11, weight: .bold))
                                            .kerning(0.55)
                                            .foregroundStyle(Color(red: 67 / 255, green: 102 / 255, blue: 77 / 255))
                                    }
                                }
                                .padding(.horizontal, 4)

                                ZStack(alignment: .trailing) {
                                    SecureField("••••••••", text: $authViewModel.password)
                                        .font(.system(size: 16, weight: .regular))
                                        .padding(.horizontal, 20)
                                        .frame(height: 55)
                                        .background(Color(red: 235 / 255, green: 232 / 255, blue: 227 / 255))

                                    Image(systemName: "lock")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(Color(red: 168 / 255, green: 162 / 255, blue: 158 / 255))
                                        .padding(.trailing, 16)
                                }
                            }

                            if let errorMessage = authViewModel.errorMessage {
                                AuthFeedbackBanner(message: errorMessage, tone: .error)
                            }

                            if let infoMessage = authViewModel.infoMessage {
                                AuthFeedbackBanner(message: infoMessage, tone: .success)
                            }

                            Button(action: {
                                authViewModel.loginUser()
                            }) {
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
                                        colors: [
                                            Color(red: 22 / 255, green: 52 / 255, blue: 41 / 255),
                                            Color(red: 45 / 255, green: 75 / 255, blue: 63 / 255)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(color: Color(red: 22 / 255, green: 52 / 255, blue: 41 / 255).opacity(0.12), radius: 12, x: 0, y: 8)
                            }
                            .buttonStyle(.plain)
                            .disabled(authViewModel.isLoading)
                        }

                        ZStack {
                            Rectangle()
                                .fill(Color(red: 229 / 255, green: 226 / 255, blue: 221 / 255).opacity(0.4))
                                .frame(height: 1)
                                .padding(.horizontal, 56)

                            Text("OR CONNECT WITH")
                                .font(.system(size: 10, weight: .bold))
                                .kerning(1)
                                .foregroundStyle(Color(red: 168 / 255, green: 162 / 255, blue: 158 / 255))
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
                            .foregroundStyle(Color(red: 65 / 255, green: 72 / 255, blue: 69 / 255))

                        Button(action: {
                            router.goToRegister()
                        }) {
                            Text("Register now")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color(red: 22 / 255, green: 52 / 255, blue: 41 / 255))
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
                    .fill(Color(red: 240 / 255, green: 237 / 255, blue: 232 / 255))
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(red: 65 / 255, green: 72 / 255, blue: 69 / 255))
            }
        }
        .buttonStyle(.plain)
        .disabled(authViewModel.isLoading)
    }
}

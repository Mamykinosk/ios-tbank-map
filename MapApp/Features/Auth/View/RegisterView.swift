import SwiftUI

struct RegisterView: View {
    @Environment(AppRouter.self) var router
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
        .background(Color(hex: "FCF9F4"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            authViewModel.clearFeedback()
        }
    }

    private var backgroundDecorations: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 194 / 255, green: 233 / 255, blue: 201 / 255).opacity(0.2))
                .frame(width: 234, height: 392)
                .blur(radius: 50)
                .offset(x: -120, y: -220)

            Ellipse()
                .fill(Color(red: 189 / 255, green: 233 / 255, blue: 255 / 255).opacity(0.1))
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
                    .fill(Color(hex: "E5E2DD"))
                    .frame(width: 64, height: 64)

                Image(systemName: "leaf.fill")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Color(hex: "163429"))
            }
            .padding(.bottom, 24)

            Text("Create Account")
                .font(.system(size: 36, weight: .bold))
                .tracking(-0.9)
                .foregroundStyle(Color(hex: "1C1C19"))
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)

            Text("Start archiving your journeys today")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(hex: "414845").opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var formCard: some View {
        VStack(spacing: 20) {
            RegisterInputField(
                title: "USERNAME (NICKNAME)",
                text: $authViewModel.username,
                placeholder: "explorer_01",
                systemImage: "person"
            )

            RegisterInputField(
                title: "EMAIL",
                text: $authViewModel.email,
                placeholder: "hello@travelmemorize.com",
                systemImage: "at"
            )

            RegisterSecureField(
                title: "PASSWORD",
                text: $authViewModel.password,
                placeholder: "••••••••",
                systemImage: "lock"
            )

            RegisterSecureField(
                title: "CONFIRM PASSWORD",
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

            Button(action: {
                authViewModel.registerUser()
            }) {
                Group {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Register")
                            .font(.system(size: 16, weight: .semibold))
                            .tracking(0.4)
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "163429"), Color(hex: "2D4B3F")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color(hex: "163429").opacity(0.1), radius: 15, x: 0, y: 8)
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
            Text("Already have an account?")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color(hex: "414845"))

            Button("Login now") {
                router.showLogin()
            }
            .buttonStyle(.plain)
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Color(hex: "163429"))
        }
        .frame(maxWidth: .infinity)
    }
}

private struct RegisterInputField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .tracking(1.1)
                .foregroundStyle(Color(hex: "163429"))
                .padding(.horizontal, 4)

            HStack(spacing: 12) {
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color(hex: "A8A29E")))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color(hex: "1C1C19"))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "A8A29E"))
            }
            .padding(.horizontal, 20)
            .frame(height: 55)
            .background(Color(hex: "EBE8E3"))
        }
    }
}


private struct RegisterSecureField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let systemImage: String

    @State private var isSecure = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .tracking(1.1)
                .foregroundStyle(Color(hex: "163429"))
                .padding(.horizontal, 4)

            HStack(spacing: 12) {
                Group {
                    if isSecure {
                        SecureField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color(hex: "A8A29E")))
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color(hex: "A8A29E")))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color(hex: "1C1C19"))

                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(hex: "A8A29E"))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .frame(height: 55)
            .background(Color(hex: "EBE8E3"))
        }
    }
}

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

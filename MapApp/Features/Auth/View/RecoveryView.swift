//
//  RecoveryView.swift
//  MapApp
//
//  Created by Иван Метальников on 14.04.2026.
//

import Foundation
import SwiftUI

struct RecoveryView: View {
    @Environment(AppRouter.self) var router
    @Bindable var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color(hex: "FCF9F4")
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
                    Color(hex: "FCF9F4"),
                    Color(hex: "FCF9F4").opacity(0),
                    Color(hex: "FCF9F4").opacity(0)
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
            Text("Reset Password")
                .font(.system(size: 36, weight: .bold))
                .tracking(-0.9)
                .foregroundStyle(Color(hex: "1C1C19"))

            Text("Enter your email to receive a reset link.")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color(hex: "414845").opacity(0.8))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text("EMAIL")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(Color(hex: "163429"))
                    .padding(.leading, 4)

                VStack(alignment: .leading, spacing: 8) {
                    TextField(
                        "",
                        text: $authViewModel.email,
                        prompt: Text("hello@travelmemorize.com")
                            .foregroundStyle(Color(hex: "A8A29E"))
                    )
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color(hex: "1C1C19"))
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 24)
                    .frame(height: 56)
                    .background(Color(hex: "EBE8E3"))
                    .overlay {
                        Capsule()
                            .stroke(Color(hex: "163429").opacity(0.05), lineWidth: 1)
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
                            Text("Send reset link")
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
                            colors: [Color(hex: "163429"), Color(hex: "2D4B3F")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color(hex: "163429").opacity(0.1), radius: 15, x: 0, y: 10)
                }
                .buttonStyle(.plain)
                .disabled(authViewModel.isLoading)

                Button {
                    router.showLogin()
                } label: {
                    Text("Back to Sign In")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(hex: "43664D"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var decorativeAccent: some View {
        HStack {
            Spacer()
            Capsule()
                .fill(Color(hex: "E5E2DD"))
                .frame(width: 64, height: 2)
            Spacer()
        }
        .opacity(0.2)
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

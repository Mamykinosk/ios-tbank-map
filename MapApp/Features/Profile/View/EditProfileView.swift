import SwiftUI

struct EditProfileView: View {
    @Environment(AppCoordinator.self) private var router
    @Environment(AuthSessionStore.self) private var authSession

    @State private var viewModel = EditProfileViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 48) {
                    profilePictureSection
                    formSection
                    privacySection
                }
                .frame(maxWidth: 448)
                .padding(.horizontal, 24)
                .padding(.top, 96)
                .padding(.bottom, 128)
                .frame(maxWidth: .infinity)
            }

            topAppBar
        }
        .task(id: authSession.currentUser?.uid) {
            await viewModel.loadProfile(user: authSession.currentUser)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var topAppBar: some View {
        HStack {
            Button {
                router.backMain()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.editProfileHeader)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(L10n.EditProfile.back))

            Spacer()

            Text(L10n.EditProfile.title)
                .font(.system(size: 20, weight: .semibold))
                .tracking(-0.5)
                .foregroundStyle(Color.editProfileHeader)

            Spacer()

            Button {
                router.goToSettings()
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.editProfileHeader)
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(L10n.EditProfile.settings))
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.8))
        .background(.ultraThinMaterial)
    }

    private var profilePictureSection: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                EditProfileAvatar()
                    .frame(width: 128, height: 128)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.editProfileAvatarStroke, lineWidth: 4)
                    }

                Button {
                    // Image upload will be wired into profile persistence later.
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.appPrimary)
                            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)

                        Image(systemName: "camera")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text(L10n.EditProfile.changeProfilePicture))
            }

            Text(L10n.EditProfile.personalIdentity)
                .font(.system(size: 16, weight: .bold))
                .tracking(1.6)
                .textCase(.uppercase)
                .foregroundStyle(Color.appPrimary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }

    private var formSection: some View {
        @Bindable var viewModel = viewModel

        return VStack(spacing: 32) {
            EditProfileTextField(
                title: L10n.EditProfile.Username.title,
                text: $viewModel.username,
                helper: L10n.EditProfile.Username.helper
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            EditProfileTextField(
                title: L10n.EditProfile.Email.title,
                text: $viewModel.email,
                keyboardType: .emailAddress
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            EditProfileTextField(
                title: L10n.EditProfile.Location.title,
                text: $viewModel.location,
                icon: "mappin",
                placeholder: L10n.EditProfile.Location.placeholder,
                placeholderColor: Color.appPlaceholder
            )

            EditProfileBioField(
                title: L10n.EditProfile.Bio.title,
                text: $viewModel.bio,
                limit: viewModel.bioLimit
            )

            feedbackSection

            Button {
                Task {
                    let didSave = await viewModel.saveProfile(user: authSession.currentUser)
                    if didSave {
                        await authSession.refreshCurrentUser()
                        router.backMain()
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 20, weight: .semibold))
                    }

                    Text(L10n.EditProfile.SaveChanges.action)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(
                    LinearGradient(
                        colors: [Color.appPrimary, Color.appAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.16), radius: 15, x: 0, y: 10)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
            .opacity(viewModel.isLoading ? 0.75 : 1)
        }
    }

    @ViewBuilder
    private var feedbackSection: some View {
        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.appError)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        } else if let infoMessage = viewModel.infoMessage {
            Text(infoMessage)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.appPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }

    private var privacySection: some View {
        VStack(spacing: 0) {
            Text(L10n.EditProfile.AccountPrivacy.title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.appTitle)
                .padding(.bottom, 8)

            Text(L10n.EditProfile.AccountPrivacy.subtitle)
                .font(.system(size: 12, weight: .regular))
                .lineSpacing(0)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.editProfileSecondaryText)
                .frame(maxWidth: 226)
                .padding(.bottom, 24)

            Button {
                // Account deactivation flow will be added with backend support.
            } label: {
                Text(L10n.EditProfile.DeactivateAccount.action)
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.appError)
                    .frame(height: 40)
                    .padding(.horizontal, 24)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 48)
        .padding(.horizontal, 32)
        .padding(.bottom, 32)
        .background(Color.editProfilePrivacyBackground)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
    }

}

private struct EditProfileTextField: View {
    let title: String
    @Binding var text: String
    var helper: String?
    var icon: String?
    var placeholder: String?
    var placeholderColor: Color?
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .tracking(0.55)
                .textCase(.uppercase)
                .foregroundStyle(Color.appPrimary)
                .padding(.leading, 4)

            HStack(spacing: 12) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(Color.appPlaceholder)
                        .frame(width: 16)
                }

                TextField("", text: $text, prompt: placeholder.map { Text($0) })
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(placeholderColor ?? Color.appTitle)
                    .keyboardType(keyboardType)
                    .frame(height: 24)
            }
            .padding(.horizontal, 20)
            .frame(height: icon == nil ? 56 : 55)
            .frame(maxWidth: .infinity)
            .background(Color.appFieldBackground)
            .overlay {
                Rectangle()
                    .stroke(Color.appPrimary.opacity(0.05), lineWidth: 1)
            }

            if let helper {
                Text(helper)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.editProfileSecondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.leading, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct EditProfileBioField: View {
    let title: String
    @Binding var text: String
    let limit: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .tracking(0.55)
                .textCase(.uppercase)
                .foregroundStyle(Color.appPrimary)
                .padding(.leading, 4)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.appTitle)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .frame(height: 128)
                    .background(Color.appFieldBackground)
                    .overlay {
                        Rectangle()
                            .stroke(Color.appPrimary.opacity(0.05), lineWidth: 1)
                    }
                    .onChange(of: text) { _, newValue in
                        if newValue.count > limit {
                            text = String(newValue.prefix(limit))
                        }
                    }

                if text.isEmpty {
                    Text(L10n.EditProfile.Bio.placeholder)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.appPlaceholder)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }

            Text("\(text.count) / \(limit)")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.appPlaceholder)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 4)
        }
    }
}

private struct EditProfileAvatar: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 18 / 255, green: 25 / 255, blue: 34 / 255))

            Ellipse()
                .fill(Color(red: 35 / 255, green: 65 / 255, blue: 71 / 255))
                .frame(width: 82, height: 52)
                .offset(y: 46)

            Ellipse()
                .fill(Color(red: 245 / 255, green: 171 / 255, blue: 119 / 255))
                .frame(width: 48, height: 58)
                .offset(y: 2)

            Path { path in
                path.move(to: CGPoint(x: 30, y: 52))
                path.addCurve(to: CGPoint(x: 64, y: 30), control1: CGPoint(x: 34, y: 30), control2: CGPoint(x: 49, y: 24))
                path.addCurve(to: CGPoint(x: 100, y: 50), control1: CGPoint(x: 84, y: 24), control2: CGPoint(x: 99, y: 35))
                path.addCurve(to: CGPoint(x: 86, y: 37), control1: CGPoint(x: 91, y: 47), control2: CGPoint(x: 90, y: 42))
                path.addCurve(to: CGPoint(x: 44, y: 44), control1: CGPoint(x: 70, y: 31), control2: CGPoint(x: 56, y: 33))
                path.addCurve(to: CGPoint(x: 30, y: 52), control1: CGPoint(x: 39, y: 47), control2: CGPoint(x: 34, y: 50))
            }
            .fill(Color(red: 94 / 255, green: 52 / 255, blue: 28 / 255))

            VStack(spacing: 8) {
                HStack(spacing: 19) {
                    Capsule()
                        .fill(Color(red: 120 / 255, green: 84 / 255, blue: 56 / 255).opacity(0.35))
                        .frame(width: 9, height: 2)

                    Capsule()
                        .fill(Color(red: 120 / 255, green: 84 / 255, blue: 56 / 255).opacity(0.35))
                        .frame(width: 9, height: 2)
                }

                Capsule()
                    .fill(Color(red: 227 / 255, green: 140 / 255, blue: 99 / 255).opacity(0.45))
                    .frame(width: 14, height: 2)
            }
            .offset(y: 5)

            Rectangle()
                .fill(Color(red: 21 / 255, green: 31 / 255, blue: 38 / 255))
                .frame(width: 44, height: 26)
                .offset(y: 54)
        }
    }
}

private extension Color {
    static let editProfileHeader = Color(red: 6 / 255, green: 78 / 255, blue: 59 / 255)
    static let editProfileAvatarStroke = Color(red: 235 / 255, green: 232 / 255, blue: 227 / 255)
    static let editProfilePrivacyBackground = Color(red: 246 / 255, green: 243 / 255, blue: 238 / 255)
    static let editProfileSecondaryText = Color(red: 120 / 255, green: 113 / 255, blue: 108 / 255)
}

#Preview {
    EditProfileView()
        .environment(AppCoordinator())
        .environment(AuthSessionStore())
}

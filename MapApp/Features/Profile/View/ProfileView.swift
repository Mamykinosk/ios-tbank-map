import SwiftUI

struct ProfileView: View {
    @Environment(AppCoordinator.self) private var router
    @Environment(AuthSessionStore.self) private var authSession

    @State private var viewModel = ProfileViewModel()
    @State private var isLanguagePickerPresented = false

    var body: some View {
        @Bindable var router = router
        @Bindable var viewModel = viewModel

        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        profileHeader

                        preferencesSection(isDarkModeEnabled: $viewModel.isDarkModeEnabled)
                            .padding(.top, 48)

                        actionsSection
                            .padding(.top, 48)

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Color.appError)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .padding(.top, 16)
                        }

                        Spacer(minLength: 160)
                    }
                    .frame(maxWidth: 448)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .frame(maxWidth: .infinity)
                }
            }

            VStack {
                Spacer()

                AppBottomTabBar(selectedTab: $router.selectedMainTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            Task {
                await viewModel.loadProfile(user: authSession.currentUser)
            }
        }
        .confirmationDialog(
            L10n.Profile.Preferences.language,
            isPresented: $isLanguagePickerPresented,
            titleVisibility: .visible
        ) {
            ForEach(ProfileLanguage.allCases) { language in
                Button {
                    viewModel.selectLanguage(language)
                } label: {
                    Text(language.title)
                }
            }

            Button(role: .cancel) {} label: {
                Text(L10n.EditProfile.back)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var profileHeader: some View {
        VStack(spacing: 0) {
            ProfileAvatarView(imageName: viewModel.avatarImageName)
                .padding(.bottom, 32)

            Text(viewModel.displayName)
                .font(.system(size: 24, weight: .bold))
                .tracking(-0.6)
                .foregroundStyle(Color.appTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(viewModel.username)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.appSecondary)
                .padding(.top, 4)

            if !viewModel.bio.isEmpty {
                Text(viewModel.bio)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.appSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
            }

            statsGrid
                .padding(.top, viewModel.bio.isEmpty ? 44 : 32)
        }
    }

    private var statsGrid: some View {
        HStack(spacing: 16) {
            ForEach(viewModel.stats) { stat in
                VStack(spacing: 4) {
                    Text(stat.value)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.appPrimary)
                        .lineLimit(1)

                    Text(stat.title)
                        .font(.system(size: 10, weight: .regular))
                        .tracking(1)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.appSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 79)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
        }
    }

    private func preferencesSection(isDarkModeEnabled: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.Profile.Preferences.title)
                .font(.system(size: 12, weight: .bold))
                .tracking(2.4)
                .textCase(.uppercase)
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, 8)

            VStack(spacing: 8) {
                ProfilePreferenceRow(
                    systemImage: "moon",
                    title: L10n.Profile.Preferences.darkMode
                ) {
                    ProfileSwitch(isOn: isDarkModeEnabled)
                }

                Button {
                    isLanguagePickerPresented = true
                } label: {
                    ProfilePreferenceRow(
                        systemImage: "globe",
                        title: L10n.Profile.Preferences.language
                    ) {
                        HStack(spacing: 8) {
                            Text(viewModel.selectedLanguage.title)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color.appPrimary)

                            Image(systemName: "chevron.down")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(Color.profileChevron)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(8)
            .background(Color.profileSettingsBackground)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 16) {
            Button {
                router.goToEditProfile()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "pencil")
                        .font(.system(size: 15, weight: .semibold))

                    Text(L10n.Profile.EditProfile.action)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.appPrimary)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
            }
            .buttonStyle(.plain)

            Button {
                if viewModel.logout() {
                    router.showAuth()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 15, weight: .semibold))

                    Text(L10n.Profile.Logout.action)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(Color.appError)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.profileLogoutBackground)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}

private struct ProfileAvatarView: View {
    let imageName: String?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                if let imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.profileAvatarTop,
                                    Color.profileAvatarBottom
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    Image(systemName: "person.fill")
                        .font(.system(size: 54, weight: .regular))
                        .foregroundStyle(Color.white.opacity(0.9))
                        .offset(y: 6)
                }
            }
            .frame(width: 104, height: 104)
            .clipShape(Circle())
            .padding(4)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.10), radius: 25, x: 0, y: 20)

            ZStack {
                Circle()
                    .fill(Color.appPrimary)

                Circle()
                    .stroke(Color.white.opacity(0.16), lineWidth: 1)

                Image(systemName: "gearshape.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 25, height: 25)
            .shadow(color: .black.opacity(0.10), radius: 15, x: 0, y: 10)
            .offset(x: -2, y: -2)
        }
        .frame(width: 112, height: 112)
    }
}

private struct ProfilePreferenceRow<Trailing: View>: View {
    let systemImage: String
    let title: String
    let trailing: Trailing

    init(
        systemImage: String,
        title: String,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.systemImage = systemImage
        self.title = title
        self.trailing = trailing()
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.appSecondaryAction)
                .frame(width: 20, height: 20)

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.appTitle)

            Spacer(minLength: 12)

            trailing
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.white)
        .contentShape(Rectangle())
    }
}

private struct ProfileSwitch: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Capsule()
                .fill(isOn ? Color.appPrimary : Color.appMuted)
                .frame(width: 40, height: 20)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .padding(.horizontal, 2)
                }
        }
        .buttonStyle(.plain)
    }
}

private extension Color {
    static let profileSettingsBackground = Color(red: 246 / 255, green: 243 / 255, blue: 238 / 255)
    static let profileLogoutBackground = Color(red: 240 / 255, green: 237 / 255, blue: 232 / 255)
    static let profileChevron = Color(red: 193 / 255, green: 200 / 255, blue: 195 / 255)
    static let profileAvatarTop = Color(red: 36 / 255, green: 35 / 255, blue: 44 / 255)
    static let profileAvatarBottom = Color(red: 67 / 255, green: 102 / 255, blue: 77 / 255)
}

#Preview {
    ProfileView()
        .environment(AppCoordinator())
        .environment(AuthSessionStore())
}

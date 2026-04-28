import SwiftUI

struct MainFlowView: View {
    @Environment(AppCoordinator.self) private var router

    var body: some View {
        @Bindable var router = router

        ZStack(alignment: .bottom) {
            NavigationStack(path: $router.mainPath) {
                currentTabView
                    .navigationDestination(for: MainRoute.self) { route in
                        switch route {
                        case .profile:
                            ProfileView()
                        case .editProfile:
                            EditProfileView()
                        case .settings:
                            MainPlaceholderView(title: "Settings", systemImage: "gearshape")
                        }
                    }
            }

            MainBottomNavigationBar(
                selectedTab: router.selectedMainTab,
                onSelect: router.selectMainTab
            )
        }
    }

    @ViewBuilder
    private var currentTabView: some View {
        switch router.selectedMainTab {
        case .map:
            MainMapView()
        case .feed:
            MainPlaceholderView(title: L10n.TabBar.feed, systemImage: "book")
        case .friends:
            MainPlaceholderView(title: L10n.TabBar.friends, systemImage: "person.2")
        case .profile:
            ProfileView()
        }
    }
}

private struct MainBottomNavigationBar: View {
    let selectedTab: MainTab
    let onSelect: (MainTab) -> Void

    var body: some View {
        HStack(spacing: 0) {
            bottomNavItem(for: .map)
            bottomNavItem(for: .feed)
            bottomNavItem(for: .friends)
            bottomNavItem(for: .profile)
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.95))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 32,
                topTrailingRadius: 32,
                style: .continuous
            )
        )
        .shadow(color: Color.appTitle.opacity(0.08), radius: 40, x: 0, y: -8)
    }

    private func bottomNavItem(for tab: MainTab) -> some View {
        Button {
            onSelect(tab)
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 22, weight: .medium))

                Text(tab.title)
                    .font(.system(size: 10, weight: .medium))
                    .tracking(0.4)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(selectedTab == tab ? Color.mainSelectedNav : Color.mainInactiveNav)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background {
                if selectedTab == tab {
                    Capsule()
                        .fill(Color.mainSelectedNavBackground)
                        .frame(width: 76, height: 48)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

private struct MainPlaceholderView: View {
    let title: LocalizedStringKey
    let systemImage: String

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(Color.appPrimary)

                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.appTitle)
            }
            .padding(.bottom, 96)
        }
    }
}

private extension MainTab {
    var title: LocalizedStringKey {
        switch self {
        case .map:
            L10n.TabBar.map
        case .feed:
            L10n.TabBar.feed
        case .friends:
            L10n.TabBar.friends
        case .profile:
            L10n.TabBar.profile
        }
    }

    var systemImage: String {
        switch self {
        case .map:
            "map"
        case .feed:
            "book"
        case .friends:
            "person.2"
        case .profile:
            "person"
        }
    }
}

private extension Color {
    static let mainSelectedNav = Color(red: 6 / 255, green: 78 / 255, blue: 59 / 255)
    static let mainSelectedNavBackground = Color(red: 209 / 255, green: 250 / 255, blue: 229 / 255).opacity(0.5)
    static let mainInactiveNav = Color(red: 120 / 255, green: 113 / 255, blue: 108 / 255)
}

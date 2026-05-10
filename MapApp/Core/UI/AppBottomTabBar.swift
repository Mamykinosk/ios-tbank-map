import SwiftUI

struct AppBottomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        ZStack(alignment: .top) {
            UnevenRoundedRectangle(
                topLeadingRadius: 32,
                topTrailingRadius: 32,
                style: .continuous
            )
            .fill(Color.appSurface.opacity(0.95))
            .shadow(color: Color.appTitle.opacity(0.08), radius: 40, x: 0, y: -8)
            .ignoresSafeArea(edges: .bottom)

            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        tabItem(tab)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 108)
    }

    private func tabItem(_ tab: AppTab) -> some View {
        let isSelected = selectedTab == tab

        return VStack(spacing: 3) {
            Image(systemName: tab.systemImage)
                .font(.system(size: 22, weight: .medium))

            Text(tab.title)
                .font(.system(size: 11, weight: .medium))
                .tracking(0.55)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
        .foregroundStyle(isSelected ? Color.appTabSelected : Color.appTabInactive)
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .background {
            if isSelected {
                Capsule()
                    .fill(Color.appTabSelectedBackground)
                    .frame(width: 84, height: 54)
            }
        }
    }
}

private extension Color {
    static let appTabSelected = Color(red: 6 / 255, green: 78 / 255, blue: 59 / 255)
    static let appTabInactive = Color(red: 120 / 255, green: 113 / 255, blue: 108 / 255)
    static let appTabSelectedBackground = Color(red: 209 / 255, green: 250 / 255, blue: 229 / 255).opacity(0.5)
}

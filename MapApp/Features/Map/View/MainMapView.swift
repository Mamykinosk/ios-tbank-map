import SwiftUI
import MapboxMaps
import CoreLocation

struct MainMapView: View {
    @State private var viewport: Viewport = .camera(
        center: CLLocationCoordinate2D(latitude: 35.6595, longitude: 139.7005),
        zoom: 13.5,
        bearing: 0,
        pitch: 0
    )

    var body: some View {
        ZStack {
            Map(viewport: $viewport) {
                Puck2D()
            }
            .mapStyle(.standard)
            .ignoresSafeArea()

            mapGradientOverlay
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button {
                        // TODO: open add memory flow
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color.mapFabIcon)
                            .frame(width: 56, height: 56)
                            .background(Color.mapFabBackground)
                            .clipShape(Circle())
                            .shadow(color: Color.mapFabBackground.opacity(0.4), radius: 30, x: 0, y: 8)
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 24)
                    .padding(.bottom, 104)
                }
            }

            VStack {
                Spacer()
                bottomNavigationBar
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    private var mapGradientOverlay: some View {
        LinearGradient(
            colors: [
                Color.appBackground.opacity(0.9),
                Color.appBackground.opacity(0),
                Color.appBackground.opacity(0),
                Color.appBackground
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var bottomNavigationBar: some View {
        HStack(spacing: 0) {
            bottomNavItem(
                title: L10n.TabBar.map,
                systemImage: "map",
                isSelected: true
            )

            bottomNavItem(
                title: L10n.TabBar.feed,
                systemImage: "book",
                isSelected: false
            )

            bottomNavItem(
                title: L10n.TabBar.friends,
                systemImage: "person.2",
                isSelected: false
            )

            bottomNavItem(
                title: L10n.TabBar.profile,
                systemImage: "person",
                isSelected: false
            )
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

    private func bottomNavItem(
        title: LocalizedStringKey,
        systemImage: String,
        isSelected: Bool
    ) -> some View {
        Button {
            // TODO: switch tab later
        } label: {
            VStack(spacing: 3) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .medium))

                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .tracking(0.4)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(isSelected ? Color.mapSelectedNav : Color.mapInactiveNav)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background {
                if isSelected {
                    Capsule()
                        .fill(Color.mapSelectedNavBackground)
                        .frame(width: 76, height: 48)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

private extension Color {
    static let mapFabBackground = Color(red: 189 / 255, green: 233 / 255, blue: 255 / 255)
    static let mapFabIcon = Color(red: 0 / 255, green: 31 / 255, blue: 42 / 255)

    static let mapSelectedNav = Color(red: 6 / 255, green: 78 / 255, blue: 59 / 255)
    static let mapSelectedNavBackground = Color(red: 209 / 255, green: 250 / 255, blue: 229 / 255).opacity(0.5)
    static let mapInactiveNav = Color(red: 120 / 255, green: 113 / 255, blue: 108 / 255)
}


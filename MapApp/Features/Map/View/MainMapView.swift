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

}

private extension Color {
    static let mapFabBackground = Color(red: 189 / 255, green: 233 / 255, blue: 255 / 255)
    static let mapFabIcon = Color(red: 0 / 255, green: 31 / 255, blue: 42 / 255)
}

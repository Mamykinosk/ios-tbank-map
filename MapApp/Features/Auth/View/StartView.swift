import SwiftUI

struct StartView: View {
    @Environment(AppCoordinator.self) var router

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let contentWidth = min(max(screenWidth - 64, 0), 384)
            let heroHeight = contentWidth * (407.5 / 326)
            let thumbSize = contentWidth * (128 / 326)
            let bottomInset = max(geometry.safeAreaInsets.bottom, 24)

            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        header
                            .frame(maxWidth: .infinity)

                        heroSection(contentWidth: contentWidth, heroHeight: heroHeight, thumbSize: thumbSize)
                            .frame(maxWidth: .infinity)

                        Spacer().frame(height: 40)

                        textSection
                            .frame(maxWidth: .infinity)

                        Spacer()

                        actionButton
                            .frame(width: contentWidth, height: 68)

                        Spacer()

                        Text("Join a community of 2M+ explorers")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.appSecondary.opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: 448)
                    .padding(.horizontal, 32)
                    .padding(.bottom, bottomInset)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 0) {
            Image("Stars")
                .font(.system(size: 33, weight: .medium))
                .foregroundStyle(Color.appAccent)
                .frame(width: 33, height: 33)

            Spacer()

            Text("Travel Memorize")
                .font(.system(size: 30, weight: .heavy))
                .tracking(-0.75)
                .foregroundStyle(Color.appTitle)
                .multilineTextAlignment(.center)

            Spacer()

            Capsule()
                .fill(Color.appMuted.opacity(0.4))
                .frame(width: 48, height: 2)
        }
    }

    private func heroSection(contentWidth: CGFloat, heroHeight: CGFloat, thumbSize: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 48, style: .continuous)
                .fill(Color.startCardBackground.opacity(0.4))
                .blur(radius: 32)

            ZStack {
                Image("StartLandscape")
                    .resizable()
                    .scaledToFill()
                    .frame(width: contentWidth, height: heroHeight)
                    .clipped()

                LinearGradient(
                    colors: [
                        Color.appBackground.opacity(0.4),
                        Color.appBackground.opacity(0)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            }
            .frame(width: contentWidth, height: heroHeight)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)

            Image("StartRiver")
                .resizable()
                .scaledToFill()
                .frame(width: thumbSize - 8, height: thumbSize - 8)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(4)
                .background(Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(Color.appBackground, lineWidth: 4)
                )
                .rotationEffect(.degrees(3))
                .shadow(color: .black.opacity(0.10), radius: 25, x: 0, y: 12)
                .offset(x: contentWidth * 0.039, y: heroHeight * 0.051)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .frame(width: contentWidth, height: heroHeight)
    }

    private var textSection: some View {
        VStack(spacing: 8) {
            Text("CURATE YOUR JOURNEY")
                .font(.system(size: 12, weight: .medium))
                .tracking(2.4)
                .textCase(.uppercase)
                .foregroundStyle(Color.appPrimary.opacity(0.6))
                .multilineTextAlignment(.center)

            Text("Every mile a memory, every\ndestination a story.")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.appSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .frame(maxWidth: 280)
        }
    }

    private var actionButton: some View {
        Button {
            router.showLogin()
        } label: {
            HStack(spacing: 8) {
                Text("Get Started")
                    .font(.system(size: 18, weight: .bold))
                    .tracking(0.45)

                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.appPrimary, Color.appAccent],
                    startPoint: UnitPoint(x: 0.0, y: 0.5),
                    endPoint: UnitPoint(x: 1.0, y: 0.5)
                )
            )
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.10), radius: 15, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}

private extension Color {
    static let startCardBackground = Color(red: 246 / 255, green: 243 / 255, blue: 238 / 255)
}

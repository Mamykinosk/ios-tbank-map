import SwiftUI

struct LaunchLoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 28) {
                logo

                VStack(spacing: 8) {
                    Text(L10n.Start.appTitle)
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundStyle(Color.appTitle)
                        .multilineTextAlignment(.center)

                    Capsule()
                        .fill(Color.appMuted.opacity(0.45))
                        .frame(width: 52, height: 2)
                }

                progressIndicator
                    .padding(.top, 4)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            isAnimating = true
        }
    }

    private var logo: some View {
        ZStack {
            Circle()
                .fill(Color.appGreenGlow.opacity(0.55))
                .frame(width: 128, height: 128)
                .blur(radius: 20)
                .scaleEffect(isAnimating ? 1.08 : 0.94)

            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.appPrimary, Color.appAccent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 88, height: 88)
                .shadow(color: .black.opacity(0.12), radius: 22, x: 0, y: 12)

            Image("Stars")
                .resizable()
                .scaledToFit()
                .frame(width: 38, height: 38)
                .foregroundStyle(Color.appOnPrimary)
                .rotationEffect(.degrees(isAnimating ? 8 : -8))
        }
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)
    }

    private var progressIndicator: some View {
        HStack(spacing: 7) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.appAccent)
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 1 : 0.65)
                    .opacity(isAnimating ? 1 : 0.35)
                    .animation(
                        .easeInOut(duration: 0.65)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.16),
                        value: isAnimating
                    )
            }
        }
        .accessibilityLabel("Loading")
    }
}

#Preview {
    LaunchLoadingView()
}

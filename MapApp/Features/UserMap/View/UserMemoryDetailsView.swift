import SwiftUI

struct UserMemoryDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    let memory: Memory

    @State private var selectedPhotoIndex = 0

    private var photoURLs: [String] {
        memory.photoURLs.filter {
            !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    private var displayTitle: String {
        let title = memory.title.trimmingCharacters(in: .whitespacesAndNewlines)

        if !title.isEmpty {
            return title
        }

        return memory.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Color.appBackground
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroGallery(width: proxy.size.width)

                        contentCard
                            .padding(.horizontal, 16)
                            .padding(.top, -42)
                            .padding(.bottom, 48)
                    }
                    .frame(width: proxy.size.width)
                }
                .frame(width: proxy.size.width)

                topBar
                    .frame(width: proxy.size.width)
                    .zIndex(10)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
            .onChange(of: memory.id) { _, _ in
                selectedPhotoIndex = 0
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 40, height: 40)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(L10n.Memories.memoryTitle)
                .font(.system(size: 20, weight: .semibold))
                .tracking(-0.5)
                .foregroundStyle(Color.appPrimary)
                .lineLimit(1)

            Spacer()

            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .background(Color.appBackground.opacity(0.8))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.black.opacity(0.03))
                .frame(height: 1)
        }
    }

    private func heroGallery(width: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            if photoURLs.isEmpty {
                RemoteMemoryImage(
                    urlString: "",
                    fallbackImageName: "recovery_forest"
                )
                .frame(width: width, height: 430)
                .clipped()
            } else {
                TabView(selection: $selectedPhotoIndex) {
                    ForEach(Array(photoURLs.enumerated()), id: \.offset) { index, url in
                        RemoteMemoryImage(
                            urlString: url,
                            fallbackImageName: "recovery_forest"
                        )
                        .frame(width: width, height: 430)
                        .clipped()
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(width: width, height: 430)
            }

            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.08)
                ],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(width: width, height: 160)
            .allowsHitTesting(false)

            if photoURLs.count > 1 {
                photoIndicator
                    .padding(.bottom, 24)
                    .offset(y: -30)
            }
        }
        .frame(width: width, height: 430)
    }

    private var photoIndicator: some View {
        HStack(spacing: 6) {
            ForEach(photoURLs.indices, id: \.self) { index in
                Circle()
                    .fill(index == selectedPhotoIndex ? Color.white : Color.white.opacity(0.45))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.14))
        .clipShape(Capsule())
    }

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 34) {
            headerSection
            storySection
        }
        .padding(.horizontal, 30)
        .padding(.top, 32)
        .padding(.bottom, 34)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.appTitle.opacity(0.06), radius: 32, x: 0, y: -8)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 8) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)

                Text(memory.placeName.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.65)
                    .foregroundStyle(Color.appPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }

            Text(displayTitle)
                .font(.system(size: 36, weight: .bold))
                .tracking(-0.9)
                .foregroundStyle(Color.appTitle)
                .lineLimit(3)
                .minimumScaleFactor(0.75)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 12, weight: .medium))

                Text(memory.visitDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundStyle(Color.userMemoryMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var storySection: some View {
        Group {
            if memory.story.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(L10n.Memories.noStoryAdded)
                    .font(.system(size: 18, weight: .medium))
                    .lineSpacing(8)
                    .foregroundStyle(Color.userMemoryMuted)
            } else {
                Text(memory.story)
                    .font(.system(size: 16, weight: .regular))
                    .lineSpacing(9)
                    .foregroundStyle(Color.appTitle.opacity(0.82))
            }
        }
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension Color {
    static let userMemoryMuted = Color(
        red: 120 / 255,
        green: 113 / 255,
        blue: 108 / 255
    )
}

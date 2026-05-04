import SwiftUI

struct MemoryGridCard: View {
    let memory: Memory

    private var displayTitle: String {
        let title = memory.title.trimmingCharacters(in: .whitespacesAndNewlines)

        if !title.isEmpty {
            return title
        }

        return memory.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 0) {
            RemoteMemoryImage(
                urlString: memory.primaryPhotoURL ?? "",
                fallbackImageName: "StartLandscape"
            )
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .clipped()

            contentSection
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.appTitle.opacity(0.05), radius: 24, x: 0, y: 10)
    }

    private var contentSection: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(displayTitle)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.appTitle)
                    .lineLimit(1)

                Text(memory.visitDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.memoryGridMuted)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "ellipsis.vertical")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.appPlaceholder)
                .frame(width: 28, height: 28)
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 22)
    }
}

private extension Color {
    static let memoryGridMuted = Color(
        red: 120 / 255,
        green: 113 / 255,
        blue: 108 / 255
    )
}

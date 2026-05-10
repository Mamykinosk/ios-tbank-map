import SwiftUI

struct MemoryDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var viewModel: MemoriesViewModel
    let memory: Memory

    @State private var isEditPresented = false
    @State private var isDeleteConfirmationPresented = false
    @State private var selectedPhotoIndex = 0

    private var currentMemory: Memory {
        viewModel.memories.first(where: { $0.id == memory.id }) ?? memory
    }

    private var photoURLs: [String] {
        currentMemory.photoURLs.filter {
            !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    private var displayTitle: String {
        let title = currentMemory.title.trimmingCharacters(in: .whitespacesAndNewlines)

        if !title.isEmpty {
            return title
        }

        return currentMemory.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                detailsTopBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroImage

                        contentCard
                            .padding(.horizontal, 65)
                            .padding(.top, -50)
                            .padding(.bottom, 48)
                    }
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            EditMemoryView(viewModel: viewModel, memory: currentMemory)
        }
        .confirmationDialog(
            L10n.Memories.deleteConfirmation,
            isPresented: $isDeleteConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button(L10n.Common.delete, role: .destructive) {
                viewModel.deleteMemory(currentMemory)
                dismiss()
            }

            Button(L10n.Common.cancel, role: .cancel) {}
        }
        .onChange(of: currentMemory.id) { _, _ in
            selectedPhotoIndex = 0
        }
        .onChange(of: photoURLs.count) { _, newCount in
            if selectedPhotoIndex >= newCount {
                selectedPhotoIndex = 0
            }
        }
    }

    private var detailsTopBar: some View {
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

            Text(L10n.Memories.appTitle)
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

    private var heroImage: some View {
        ZStack(alignment: .bottom) {
            if photoURLs.isEmpty {
                RemoteMemoryImage(
                    urlString: "",
                    fallbackImageName: "recovery_forest"
                )
                .frame(height: 320)
                .frame(maxWidth: .infinity)
                .clipped()
            } else {
                TabView(selection: $selectedPhotoIndex) {
                    ForEach(Array(photoURLs.enumerated()), id: \.offset) { index, url in
                        RemoteMemoryImage(
                            urlString: url,
                            fallbackImageName: "recovery_forest"
                        )
                        .frame(height: 320)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 320)
                .frame(maxWidth: .infinity)
            }

            LinearGradient(
                colors: [
                    Color.clear,
                    Color.appBackground.opacity(0.95)
                ],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 120)
            .allowsHitTesting(false)

            if !photoURLs.isEmpty {
                photoIndicator
                    .padding(.bottom, 60)
            }
        }
    }

    private var photoIndicator: some View {
        HStack(spacing: 7) {
            ForEach(photoURLs.indices, id: \.self) { index in
                Circle()
                    .fill(index == selectedPhotoIndex ? Color.white : Color.white.opacity(0.45))
                    .frame(
                        width: index == selectedPhotoIndex ? 9 : 7,
                        height: index == selectedPhotoIndex ? 9 : 7
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.22))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 3)
    }

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 28) {
            headerSection

            if !currentMemory.story.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                storySection
            }

            actionButtons
        }
        .padding(.horizontal, 28)
        .padding(.top, 32)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.appTitle.opacity(0.06), radius: 28, x: 0, y: 10)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "mappin")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)

                Text(currentMemory.placeName.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.4)
                    .foregroundStyle(Color.appPrimary)
                    .lineLimit(2)
            }

            Text(displayTitle)
                .font(.system(size: 34, weight: .bold))
                .tracking(-0.8)
                .foregroundStyle(Color.appTitle)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 12, weight: .medium))

                Text(currentMemory.visitDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(Color.memoryDetailsMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var storySection: some View {
        Text(currentMemory.story)
            .font(.system(size: 16, weight: .regular))
            .lineSpacing(7)
            .foregroundStyle(Color.appTitle.opacity(0.78))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var actionButtons: some View {
        VStack(spacing: 14) {
            Button {
                isEditPresented = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text(L10n.Memories.editTitle)
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.appPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .overlay {
                    Capsule()
                        .stroke(Color.appPrimary, lineWidth: 2)
                }
            }
            .buttonStyle(.plain)

            Button {
                isDeleteConfirmationPresented = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text(L10n.Memories.deletePermanently)
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.appError)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 4)
    }
}

private extension Color {
    static let memoryDetailsMuted = Color(
        red: 120 / 255,
        green: 113 / 255,
        blue: 108 / 255
    )
}

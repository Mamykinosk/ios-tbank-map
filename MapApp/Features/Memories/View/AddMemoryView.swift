import SwiftUI
import PhotosUI

struct AddMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: MemoriesViewModel

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isCancelConfirmationPresented = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            backgroundDecorations

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 40) {
                    photoSection
                    formSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 80)
                .padding(.bottom, 170)
            }

            VStack {
                AppTopBar(
                    title: L10n.Memories.newMemoryTitle,
                    showsBackButton: true,
                    showsSettingsButton: true,
                    onBack: {
                        isCancelConfirmationPresented = true
                    }
                )

                Spacer()
            }

            VStack {
                Spacer()
                bottomActionBar
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            viewModel.prepareDraftForAdd()
        }
        .onChange(of: selectedItems) { _, newItems in
            loadSelectedImages(from: newItems)
        }
        .confirmationDialog(
            L10n.Memories.cancelAddConfirmation,
            isPresented: $isCancelConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button(L10n.Common.cancel, role: .destructive) {
                viewModel.closeAddMemory()
                dismiss()
            }

            Button(L10n.Memories.stay, role: .cancel) {}
        }
    }

    private var backgroundDecorations: some View {
        ZStack {
            Circle()
                .fill(Color.addMemoryGreenGlow)
                .frame(width: 256, height: 256)
                .blur(radius: 40)
                .offset(x: 140, y: -260)

            Circle()
                .fill(Color.addMemoryBlueGlow)
                .frame(width: 288, height: 288)
                .blur(radius: 50)
                .offset(x: -130, y: 260)
        }
        .opacity(0.4)
        .ignoresSafeArea()
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(L10n.Memories.capture)
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appPrimary)

                Spacer()

                (Text("\(viewModel.draft.allPhotoCount) / 10 ") + Text(L10n.Memories.photos))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.memoryMutedText)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if viewModel.draft.allPhotoCount < 10 {
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: max(0, 10 - viewModel.draft.allPhotoCount),
                            matching: .images
                        ) {
                            addPhotosTile
                        }
                    }

                    ForEach(Array(viewModel.draft.newImages.enumerated()), id: \.offset) { index, image in
                        selectedImageTile(image: image, index: index)
                    }
                }
            }
        }
    }

    private var addPhotosTile: some View {
        VStack(spacing: 8) {
            Image(systemName: "camera.badge.plus")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.appPrimary)

            Text(L10n.Memories.addPhotos)
                .font(.system(size: 10, weight: .semibold))
                .tracking(-0.5)
                .foregroundStyle(Color.appPrimary)
        }
        .frame(width: 128, height: 176)
        .background(Color.appFieldBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(
                    Color.memoryDashedBorder,
                    style: StrokeStyle(lineWidth: 2, dash: [6, 4])
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
    }

    private func selectedImageTile(image: UIImage, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 128, height: 176)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .clipped()

            Button {
                guard viewModel.draft.newImages.indices.contains(index) else { return }
                viewModel.draft.newImages.remove(at: index)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 18, height: 18)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(8)
        }
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 40) {
            memoryTextField(
                title: L10n.Memories.placeNameRequired,
                placeholder: L10n.Memories.placeNamePlaceholder,
                text: $viewModel.draft.title
            )

            visitDateField

            memoryTextEditor(
                title: L10n.Memories.historyStory,
                placeholder: L10n.Memories.storyPlaceholder,
                text: $viewModel.draft.story
            )
        }
    }

    private func memoryTextField(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(Color.appPrimary)

            TextField(
                "",
                text: text,
                prompt: Text(placeholder)
                    .foregroundStyle(Color.appPlaceholder)
            )
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Color.appTitle)
            .padding(.horizontal, 16)
            .frame(height: 55)
            .background(Color.appMuted.opacity(0.5))
        }
    }

    private var visitDateField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.Memories.visitDateRequired)
                .font(.system(size: 12, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(Color.appPrimary)

            DatePicker(
                "",
                selection: $viewModel.draft.visitDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 56)
            .background(Color.appMuted.opacity(0.5))
        }
    }

    private func memoryTextEditor(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(Color.appPrimary)

            ZStack(alignment: .topLeading) {
                TextEditor(text: text)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.appTitle)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)

                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.appPlaceholder)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 152)
            .background(Color.appMuted.opacity(0.5))
        }
    }

    private var bottomActionBar: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.saveDraft()
            } label: {
                HStack(spacing: 8) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .semibold))

                        Text(L10n.Memories.saveMemory)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(viewModel.draft.isValid ? Color.appPrimary : Color.appPrimary.opacity(0.4))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.draft.isValid || viewModel.isLoading)

            Button {
                isCancelConfirmationPresented = true
            } label: {
                Text(L10n.Common.cancel)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(1.1)
                    .foregroundStyle(Color.appAccent)
                    .frame(maxWidth: .infinity)
                    .frame(height: 33)
            }
            .buttonStyle(.plain)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.appError)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 32)
        .background(Color.white.opacity(0.9))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 32,
                topTrailingRadius: 32,
                style: .continuous
            )
        )
        .shadow(color: Color.appTitle.opacity(0.06), radius: 40, x: 0, y: -8)
    }

    private func loadSelectedImages(from items: [PhotosPickerItem]) {
        Task {
            var images: [UIImage] = []

            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    images.append(image)
                }
            }

            await MainActor.run {
                let availableSlots = max(0, 10 - viewModel.draft.allPhotoCount)
                viewModel.draft.newImages.append(contentsOf: images.prefix(availableSlots))
                selectedItems = []
            }
        }
    }
}

private extension Color {
    static let addMemoryGreenGlow = Color(red: 194 / 255, green: 233 / 255, blue: 201 / 255)
    static let addMemoryBlueGlow = Color(red: 189 / 255, green: 233 / 255, blue: 255 / 255)
    static let memoryMutedText = Color(red: 120 / 255, green: 113 / 255, blue: 108 / 255)
    static let memoryDashedBorder = Color(red: 193 / 255, green: 200 / 255, blue: 195 / 255)
}

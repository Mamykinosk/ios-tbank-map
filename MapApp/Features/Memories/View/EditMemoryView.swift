import SwiftUI
import PhotosUI

struct EditMemoryView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var viewModel: MemoriesViewModel
    let memory: Memory

    @State private var draft: MemoryDraft
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isCancelConfirmationPresented = false

    init(viewModel: MemoriesViewModel, memory: Memory) {
        self.viewModel = viewModel
        self.memory = memory
        _draft = State(initialValue: MemoryDraft(memory: memory))
    }

    var body: some View {
        ZStack {
            Color.appWarmSurface
                .ignoresSafeArea()

            backgroundDecoration

            ScrollView(showsIndicators: false) {
                VStack {
                    editCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 96)
                .padding(.bottom, 48)
            }

            VStack {
                AppTopBar(
                    title: L10n.Memories.editMarkerTitle,
                    showsBackButton: true,
                    showsSettingsButton: false,
                    onBack: {
                        isCancelConfirmationPresented = true
                    }
                )

                Spacer()
            }
        }
        .onChange(of: selectedItems) { _, newItems in
            loadSelectedImages(from: newItems)
        }
        .confirmationDialog(
            L10n.Memories.cancelEditConfirmation,
            isPresented: $isCancelConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button(L10n.Common.cancel, role: .destructive) {
                dismiss()
            }

            Button(L10n.Memories.stay, role: .cancel) {}
        }
    }

    private var backgroundDecoration: some View {
        ZStack {
            Circle()
                .fill(Color.appPrimary.opacity(0.05))
                .frame(width: 320, height: 320)
                .blur(radius: 32)
                .offset(x: -150, y: -320)

            Circle()
                .fill(Color.appAccent.opacity(0.05))
                .frame(width: 320, height: 320)
                .blur(radius: 32)
                .offset(x: 160, y: 360)
        }
        .ignoresSafeArea()
    }

    private var editCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            brandIcon
            photoGallery
            formSection
            actionButtons
            dangerZone
        }
        .padding(32)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.black.opacity(0.03), radius: 25, x: 0, y: 12)
    }

    private var brandIcon: some View {
        HStack {
            Spacer()

            Image(systemName: "leaf.circle")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.appAccent)
                .frame(width: 41, height: 41)
                .background(Color.editIconBackground)
                .clipShape(Circle())

            Spacer()
        }
    }

    private var photoGallery: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(L10n.Memories.photoGallery)
                    .font(.system(size: 10, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(Color.appAccent)

                Spacer()

                (Text("\(draft.allPhotoCount) ") + Text(L10n.Memories.items))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(Color.editMuted.opacity(0.6))
            }
            .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(draft.existingPhotoURLs.enumerated()), id: \.offset) { index, urlString in
                        existingPhotoTile(urlString: urlString, index: index)
                    }

                    ForEach(Array(draft.newImages.enumerated()), id: \.offset) { index, image in
                        newPhotoTile(image: image, index: index)
                    }

                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: max(0, 10 - draft.allPhotoCount),
                        matching: .images
                    ) {
                        addPhotoTile
                    }
                }
            }
        }
    }

    private func existingPhotoTile(urlString: String, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            RemoteMemoryImage(urlString: urlString, fallbackImageName: "StartLandscape")
                .frame(width: 87, height: 87)
                .clipped()

            removeButton {
                draft.existingPhotoURLs.remove(at: index)
            }
        }
    }

    private func newPhotoTile(image: UIImage, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 87, height: 87)
                .clipped()

            removeButton {
                draft.newImages.remove(at: index)
            }
        }
    }

    private func removeButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 7, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 16, height: 16)
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(4)
    }

    private var addPhotoTile: some View {
        VStack(spacing: 4) {
            Image(systemName: "camera.badge.plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.appAccent.opacity(0.7))

            Text(L10n.Memories.add)
                .font(.system(size: 9, weight: .bold))
                .tracking(0.45)
                .foregroundStyle(Color.appAccent.opacity(0.6))
        }
        .frame(width: 87, height: 87)
        .background(Color.appWarmSurface)
        .overlay {
            Rectangle()
                .stroke(
                    Color.appAccent.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: [5, 4])
                )
        }
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            editTextField(
                title: L10n.Memories.placeName,
                text: $draft.title
            )

            visitDateField

            editTextEditor(
                title: L10n.Memories.theStory,
                text: $draft.story
            )
        }
        .padding(.top, 8)
    }

    private func editTextField(
        title: LocalizedStringKey,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(2)
                .foregroundStyle(Color.appAccent)
                .padding(.leading, 4)

            TextField("", text: text)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.appTitle)
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(Color.appWarmSurface)
        }
    }

    private var visitDateField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L10n.Memories.visitDate)
                .font(.system(size: 10, weight: .bold))
                .tracking(2)
                .foregroundStyle(Color.appAccent)
                .padding(.leading, 4)

            DatePicker(
                "",
                selection: $draft.visitDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 54)
            .background(Color.appWarmSurface)
        }
    }

    private func editTextEditor(
        title: LocalizedStringKey,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(2)
                .foregroundStyle(Color.appAccent)
                .padding(.leading, 4)

            TextEditor(text: text)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.appTitle)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(height: 170)
                .background(Color.appWarmSurface)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                Task {
                    viewModel.draft = draft
                    let success = await viewModel.updateMemory(memory)

                    if success {
                        dismiss()
                    }
                }
            } label: {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(L10n.Memories.saveChanges)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(draft.isValid ? Color.appPrimary : Color.appPrimary.opacity(0.4))
                .clipShape(Capsule())
                .shadow(color: Color.appPrimary.opacity(0.1), radius: 15, x: 0, y: 10)
            }
            .buttonStyle(.plain)
            .disabled(!draft.isValid || viewModel.isLoading)

            Button {
                isCancelConfirmationPresented = true
            } label: {
                Text(L10n.Common.cancel)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appAccent.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
            }
            .buttonStyle(.plain)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.appError)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 8)
    }

    private var dangerZone: some View {
        Button {
            viewModel.deleteMemory(memory)
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                    .font(.system(size: 10, weight: .medium))

                Text(L10n.Memories.deleteMarker)
                    .font(.system(size: 10, weight: .medium))
                    .tracking(1)
            }
            .foregroundStyle(Color.appError.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.appWarmSurface)
                    .frame(height: 1)
            }
        }
        .buttonStyle(.plain)
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
                let availableSlots = max(0, 10 - draft.allPhotoCount)
                draft.newImages.append(contentsOf: images.prefix(availableSlots))
                selectedItems = []
            }
        }
    }
}

private extension Color {
    static let editIconBackground = Color(red: 232 / 255, green: 239 / 255, blue: 235 / 255)
    static let editMuted = Color(red: 114 / 255, green: 121 / 255, blue: 116 / 255)
}

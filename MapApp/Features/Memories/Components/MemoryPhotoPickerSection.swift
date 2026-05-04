import SwiftUI
import PhotosUI

struct MemoryPhotoPickerSection: View {
    let title: LocalizedStringKey
    var existingPhotoURLs: [String]
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    var onRemoveExisting: ((String) -> Void)?

    private var totalCount: Int {
        existingPhotoURLs.count + selectedImages.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.appPrimary)

                Spacer()

                (Text("\(totalCount) / 10 ") + Text(L10n.Memories.photos))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.photoMuted)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: max(0, 10 - existingPhotoURLs.count),
                        matching: .images
                    ) {
                        addPhotoTile
                    }

                    ForEach(existingPhotoURLs, id: \.self) { url in
                        ZStack(alignment: .topTrailing) {
                            RemoteMemoryImage(urlString: url, fallbackImageName: "StartLandscape")
                                .frame(width: 128, height: 176)
                                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

                            removeButton {
                                onRemoveExisting?(url)
                            }
                        }
                    }

                    ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 176)
                                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

                            removeButton {
                                selectedImages.remove(at: index)
                            }
                        }
                    }
                }
            }
            .onChange(of: selectedItems) { items in
                Task {
                    await loadImages(from: items)
                }
            }
        }
    }

    private var addPhotoTile: some View {
        VStack(spacing: 8) {
            Image(systemName: "camera")
                .font(.system(size: 22, weight: .semibold))

            Text(L10n.Memories.addPhotos)
                .font(.system(size: 10, weight: .semibold))
        }
        .foregroundStyle(Color.appPrimary)
        .frame(width: 128, height: 176)
        .background(Color.appFieldBackground)
        .overlay {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.photoPickerBorder, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
    }

    private func removeButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 18, height: 18)
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
                .padding(8)
        }
        .buttonStyle(.plain)
    }

    @MainActor
    private func loadImages(from items: [PhotosPickerItem]) async {
        var images: [UIImage] = []

        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                images.append(image)
            }
        }

        selectedImages = images
    }
}

private extension Color {
    static let photoPickerBorder = Color(red: 193 / 255, green: 200 / 255, blue: 195 / 255)
    static let photoMuted = Color(red: 120 / 255, green: 113 / 255, blue: 108 / 255)
}

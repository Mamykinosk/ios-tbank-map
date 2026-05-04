import SwiftUI

struct RemoteMemoryImage: View {
    let urlString: String?
    let fallbackImageName: String
    var contentMode: ContentMode = .fill

    var body: some View {
        GeometryReader { proxy in
            Group {
                if let urlString,
                   !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: contentMode)
                                .frame(width: proxy.size.width, height: proxy.size.height)

                        case .failure:
                            fallbackImage
                                .frame(width: proxy.size.width, height: proxy.size.height)

                        case .empty:
                            ProgressView()
                                .frame(width: proxy.size.width, height: proxy.size.height)

                        @unknown default:
                            fallbackImage
                                .frame(width: proxy.size.width, height: proxy.size.height)
                        }
                    }
                } else {
                    fallbackImage
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
        }
    }

    private var fallbackImage: some View {
        Image(fallbackImageName)
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

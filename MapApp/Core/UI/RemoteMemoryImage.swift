import SwiftUI
import UIKit

struct RemoteMemoryImage: View {
    let urlString: String?
    let fallbackImageName: String
    var contentMode: ContentMode = .fill

    @StateObject private var loader = RemoteMemoryImageLoader()

    private var imageURL: URL? {
        guard let urlString,
              !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return nil
        }

        return URL(string: urlString)
    }

    var body: some View {
        GeometryReader { proxy in
            Group {
                if let image = loader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                } else if loader.didFail || imageURL == nil {
                    fallbackImage
                        .frame(width: proxy.size.width, height: proxy.size.height)
                } else {
                    ProgressView()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
        }
        .task(id: imageURL) {
            await loader.load(url: imageURL)
        }
    }

    private var fallbackImage: some View {
        Image(fallbackImageName)
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

@MainActor
private final class RemoteMemoryImageLoader: ObservableObject {
    @Published private(set) var image: UIImage?
    @Published private(set) var didFail = false

    private var currentURL: URL?

    func load(url: URL?) async {
        guard currentURL != url else {
            return
        }

        currentURL = url
        image = nil
        didFail = false

        guard let url else {
            didFail = true
            return
        }

        do {
            let loadedImage = try await MemoryImageCache.shared.image(for: url)

            guard currentURL == url, !Task.isCancelled else {
                return
            }

            image = loadedImage
        } catch {
            guard currentURL == url, !Task.isCancelled else {
                return
            }

            didFail = true
        }
    }
}

private final class MemoryImageCache {
    static let shared = MemoryImageCache()

    private let memoryCache = NSCache<NSURL, UIImage>()
    private let diskCache: URLCache
    private let cacheAge: TimeInterval = 30 * 24 * 60 * 60
    private let cachedAtKey = "cachedAt"

    private init() {
        memoryCache.countLimit = 250
        memoryCache.totalCostLimit = 80 * 1024 * 1024

        diskCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 300 * 1024 * 1024,
            diskPath: "MemoryPhotoCache"
        )
    }

    func image(for url: URL) async throws -> UIImage {
        let cacheKey = url as NSURL

        if let image = memoryCache.object(forKey: cacheKey) {
            return image
        }

        let request = URLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 30
        )

        if let cachedResponse = diskCache.cachedResponse(for: request),
           isFresh(cachedResponse),
           let image = UIImage(data: cachedResponse.data) {
            memoryCache.setObject(image, forKey: cacheKey, cost: cachedResponse.data.count)
            return image
        }

        diskCache.removeCachedResponse(for: request)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }

        memoryCache.setObject(image, forKey: cacheKey, cost: data.count)

        let cachedResponse = CachedURLResponse(
            response: response,
            data: data,
            userInfo: [cachedAtKey: Date()],
            storagePolicy: .allowed
        )
        diskCache.storeCachedResponse(cachedResponse, for: request)

        return image
    }

    private func isFresh(_ cachedResponse: CachedURLResponse) -> Bool {
        guard let cachedAt = cachedResponse.userInfo?[cachedAtKey] as? Date else {
            return false
        }

        return Date().timeIntervalSince(cachedAt) < cacheAge
    }
}

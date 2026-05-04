import Foundation
import Observation
import CoreLocation
import FirebaseFirestore
import MapboxMaps

@MainActor
@Observable final class UserMapViewModel {
    var viewport: Viewport = .camera(
        center: CLLocationCoordinate2D(latitude: 35.6595, longitude: 139.7005),
        zoom: 11.5,
        bearing: 0,
        pitch: 0
    )

    var memories: [Memory] = []
    var selectedMemory: Memory?
    var isLoading = false
    var errorMessage: String?

    private var listener: ListenerRegistration?

    func startListening(userId: String) {
        stopListening()

        isLoading = true
        errorMessage = nil

        listener = MemoryService.shared.listenMemories(userId: userId) { [weak self] result in
            Task { @MainActor in
                guard let self else {
                    return
                }

                self.isLoading = false

                switch result {
                case .success(let memories):
                    self.memories = memories

                    if let first = memories.first {
                        self.viewport = .camera(
                            center: first.coordinate,
                            zoom: 10.5,
                            bearing: 0,
                            pitch: 0
                        )
                    }

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }
}

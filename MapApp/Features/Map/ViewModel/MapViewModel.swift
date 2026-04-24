import Foundation
import Observation
import CoreLocation
import MapboxMaps

@MainActor
@Observable
final class MapViewModel {
    var viewport: Viewport = .camera(
        center: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
        zoom: 10,
        bearing: 0,
        pitch: 0
    )

    var markers: [MemoryMarker] = []
    var pendingCoordinate: CLLocationCoordinate2D?
    var isAddSheetPresented = false

    func focusOnUser() {
        viewport = .followPuck(zoom: 14, bearing: .heading)
    }

    func prepareMarkerCreation(at coordinate: CLLocationCoordinate2D) {
        pendingCoordinate = coordinate
        isAddSheetPresented = true
    }

    func saveMarker(title: String, visitDate: Date) {
        guard let coordinate = pendingCoordinate else { return }

        markers.append(
            MemoryMarker(
                title: title,
                coordinate: coordinate,
                visitDate: visitDate
            )
        )

        pendingCoordinate = nil
        isAddSheetPresented = false
    }
}

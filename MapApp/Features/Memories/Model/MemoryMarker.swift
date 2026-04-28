import Foundation
import CoreLocation

struct MemoryMarker: Identifiable, Hashable {
    let id: UUID
    var title: String
    var coordinate: CLLocationCoordinate2D
    var visitDate: Date

    init(
        id: UUID = UUID(),
        title: String,
        coordinate: CLLocationCoordinate2D,
        visitDate: Date
    ) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.visitDate = visitDate
    }

    static func == (lhs: MemoryMarker, rhs: MemoryMarker) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

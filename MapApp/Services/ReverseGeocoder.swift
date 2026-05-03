import Foundation
import CoreLocation

struct ResolvedMemoryLocation {
    let city: String
    let country: String

    var automaticPlaceName: String {
        [country, city]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

final class ReverseGeocoder {
    static let shared = ReverseGeocoder()

    private init() {}

    func resolve(coordinate: CLLocationCoordinate2D) async -> ResolvedMemoryLocation {
        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        do {
            let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
            let placemark = placemarks.first

            let city = placemark?.locality
                ?? placemark?.subAdministrativeArea
                ?? placemark?.administrativeArea
                ?? ""

            let country = placemark?.country ?? ""

            return ResolvedMemoryLocation(
                city: city.trimmingCharacters(in: .whitespacesAndNewlines),
                country: country.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        } catch {
            return ResolvedMemoryLocation(city: "", country: "")
        }
    }
}

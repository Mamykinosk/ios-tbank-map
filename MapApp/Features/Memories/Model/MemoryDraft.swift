import Foundation
import CoreLocation
import UIKit

struct MemoryDraft {
    var title: String
    var placeName: String
    var city: String
    var country: String
    var story: String
    var visitDate: Date
    var coordinate: CLLocationCoordinate2D?
    var existingPhotoURLs: [String]
    var newImages: [UIImage]

    init(
        title: String = "",
        placeName: String = "",
        city: String = "",
        country: String = "",
        story: String = "",
        visitDate: Date = Date(),
        coordinate: CLLocationCoordinate2D? = nil,
        existingPhotoURLs: [String] = [],
        newImages: [UIImage] = []
    ) {
        self.title = title
        self.placeName = placeName
        self.city = city
        self.country = country
        self.story = story
        self.visitDate = visitDate
        self.coordinate = coordinate
        self.existingPhotoURLs = existingPhotoURLs
        self.newImages = newImages
    }

    init(memory: Memory) {
        self.title = memory.title
        self.placeName = memory.placeName
        self.city = memory.city
        self.country = memory.country
        self.story = memory.story
        self.visitDate = memory.visitDate
        self.coordinate = memory.coordinate
        self.existingPhotoURLs = memory.photoURLs
        self.newImages = []
    }

    var allPhotoCount: Int {
        existingPhotoURLs.count + newImages.count
    }

    var normalizedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedPlaceName: String {
        placeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedCity: String {
        city.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedCountry: String {
        country.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedStory: String {
        story.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isValid: Bool {
        !normalizedTitle.isEmpty
        && coordinate != nil
        && allPhotoCount > 0
    }

    mutating func reset() {
        title = ""
        placeName = ""
        city = ""
        country = ""
        story = ""
        visitDate = Date()
        coordinate = nil
        existingPhotoURLs = []
        newImages = []
    }
}

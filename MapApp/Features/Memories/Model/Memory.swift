import Foundation
import CoreLocation
import FirebaseFirestore

struct Memory: Identifiable, Hashable {
    let id: String
    let userId: String

    var title: String
    var placeName: String
    var city: String
    var country: String
    var story: String
    var visitDate: Date
    var coordinate: CLLocationCoordinate2D
    var photoURLs: [String]
    var createdAt: Date
    var updatedAt: Date

    var primaryPhotoURL: String? {
        photoURLs.first
    }

    init(
        id: String = UUID().uuidString,
        userId: String,
        title: String,
        placeName: String,
        city: String = "",
        country: String = "",
        story: String,
        visitDate: Date,
        coordinate: CLLocationCoordinate2D,
        photoURLs: [String],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.placeName = placeName
        self.city = city
        self.country = country
        self.story = story
        self.visitDate = visitDate
        self.coordinate = coordinate
        self.photoURLs = photoURLs
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init?(id: String, data: [String: Any]) {
        guard
            let userId = data["userId"] as? String,
            let title = data["title"] as? String,
            let placeName = data["placeName"] as? String,
            let story = data["story"] as? String,
            let latitude = data["latitude"] as? CLLocationDegrees,
            let longitude = data["longitude"] as? CLLocationDegrees
        else {
            return nil
        }

        self.id = id
        self.userId = userId
        self.title = title
        self.placeName = placeName
        self.city = data["city"] as? String ?? ""
        self.country = data["country"] as? String ?? ""
        self.story = story
        self.coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )

        if let photoURLs = data["photoURLs"] as? [String] {
            self.photoURLs = photoURLs.filter {
                !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
        } else if let primaryPhotoURL = data["primaryPhotoURL"] as? String,
                  !primaryPhotoURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.photoURLs = [primaryPhotoURL]
        } else if let photoURL = data["photoURL"] as? String,
                  !photoURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.photoURLs = [photoURL]
        } else {
            self.photoURLs = []
        }

        if let visitTimestamp = data["visitDate"] as? Timestamp {
            self.visitDate = visitTimestamp.dateValue()
        } else {
            self.visitDate = Date()
        }

        if let createdTimestamp = data["createdAt"] as? Timestamp {
            self.createdAt = createdTimestamp.dateValue()
        } else {
            self.createdAt = Date()
        }

        if let updatedTimestamp = data["updatedAt"] as? Timestamp {
            self.updatedAt = updatedTimestamp.dateValue()
        } else {
            self.updatedAt = Date()
        }
    }

    var firestoreData: [String: Any] {
        [
            "userId": userId,
            "title": title,
            "placeName": placeName,
            "city": city,
            "country": country,
            "story": story,
            "visitDate": Timestamp(date: visitDate),
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            "photoURLs": photoURLs,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }

    static func == (lhs: Memory, rhs: Memory) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

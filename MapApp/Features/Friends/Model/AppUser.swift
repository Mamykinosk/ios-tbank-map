import Foundation
import FirebaseFirestore

struct AppUser: Identifiable, Hashable {
    let id: String
    var username: String
    var searchUsername: String
    var email: String
    var avatarURL: String?
    var bio: String
    var location: String
    var stats: UserStats

    init(
        id: String,
        username: String,
        searchUsername: String,
        email: String,
        avatarURL: String? = nil,
        bio: String = "",
        location: String = "",
        stats: UserStats = UserStats()
    ) {
        self.id = id
        self.username = username
        self.searchUsername = searchUsername
        self.email = email
        self.avatarURL = avatarURL
        self.bio = bio
        self.location = location
        self.stats = stats
    }

    init?(id: String, data: [String: Any]) {
        guard
            let username = data["username"] as? String,
            let email = data["email"] as? String
        else {
            return nil
        }

        self.id = id
        self.username = username
        self.searchUsername = data["searchUsername"] as? String ?? username.lowercased()
        self.email = email
        self.avatarURL = data["avatarURL"] as? String
        self.bio = data["bio"] as? String ?? ""
        self.location = data["location"] as? String ?? ""

        if let statsData = data["stats"] as? [String: Any] {
            self.stats = UserStats(data: statsData)
        } else {
            self.stats = UserStats()
        }
    }

    var firestoreData: [String: Any] {
        [
            "username": username,
            "searchUsername": searchUsername,
            "email": email,
            "avatarURL": avatarURL as Any,
            "bio": bio,
            "location": location,
            "stats": stats.firestoreData,
            "updatedAt": FieldValue.serverTimestamp()
        ]
    }
}

struct UserStats: Hashable {
    var countries: Int
    var cities: Int
    var memoriesCount: Int

    init(
        countries: Int = 0,
        cities: Int = 0,
        memoriesCount: Int = 0
    ) {
        self.countries = countries
        self.cities = cities
        self.memoriesCount = memoriesCount
    }

    init(data: [String: Any]) {
        self.countries = data["countries"] as? Int ?? 0
        self.cities = data["cities"] as? Int ?? 0
        self.memoriesCount = data["memoriesCount"] as? Int ?? 0
    }

    var firestoreData: [String: Any] {
        [
            "countries": countries,
            "cities": cities,
            "memoriesCount": memoriesCount
        ]
    }
}

import FirebaseAuth
import FirebaseFirestore
import Foundation

struct UserProfile {
    var username: String
    var email: String
    var bio: String
    var location: String
    var stats: UserProfileStats

    static func fallback(email: String?) -> UserProfile {
        let sanitizedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let emailPrefix = sanitizedEmail
            .split(separator: "@")
            .first
            .map { String($0).replacingOccurrences(of: ".", with: "_") } ?? "traveler"

        return UserProfile(
            username: emailPrefix,
            email: sanitizedEmail,
            bio: "",
            location: "",
            stats: UserProfileStats(countries: 0, cities: 0, memoriesCount: 0)
        )
    }
}

struct UserProfileStats {
    var countries: Int
    var cities: Int
    var memoriesCount: Int
}

enum ProfileServiceError: LocalizedError {
    case unauthenticated
    case invalidUsername
    case invalidEmail
    case usernameTaken

    var errorDescription: String? {
        switch self {
        case .unauthenticated:
            return "You need to sign in again."
        case .invalidUsername:
            return "Username can contain only English letters, numbers and underscores."
        case .invalidEmail:
            return "Enter a valid email address."
        case .usernameTaken:
            return "This username is already taken."
        }
    }
}

final class ProfileService {
    static let shared = ProfileService()

    private let db = Firestore.firestore()
    private let usernamePattern = /^[A-Za-z0-9_]{3,30}$/
    private let emailPattern = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

    private init() {}

    func fetchProfile(uid: String, authEmail: String?) async throws -> UserProfile {
        let document = try await userDocument(uid: uid).getDocument()
        var profile = UserProfile.fallback(email: authEmail)

        guard let data = document.data() else {
            return profile
        }

        if let username = trimmedNonEmpty(data["username"] as? String) {
            profile.username = username
        }

        if let authEmail = trimmedNonEmpty(authEmail) {
            profile.email = authEmail
        } else if let email = trimmedNonEmpty(data["email"] as? String) {
            profile.email = email
        }

        if let bio = data["bio"] as? String {
            profile.bio = bio
        }

        if let location = data["location"] as? String {
            profile.location = location
        }

        if let stats = data["stats"] as? [String: Any] {
            profile.stats = UserProfileStats(
                countries: intValue(from: stats["countries"]),
                cities: intValue(from: stats["cities"]),
                memoriesCount: intValue(from: stats["memoriesCount"])
            )
        }

        return profile
    }

    func updateProfile(
        user: User,
        username: String,
        email: String,
        bio: String,
        location: String
    ) async throws -> UserProfile {
        let sanitizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let sanitizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let sanitizedBio = String(bio.trimmingCharacters(in: .whitespacesAndNewlines).prefix(160))
        let sanitizedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)

        guard sanitizedUsername.wholeMatch(of: usernamePattern) != nil else {
            throw ProfileServiceError.invalidUsername
        }

        guard sanitizedEmail.wholeMatch(of: emailPattern) != nil else {
            throw ProfileServiceError.invalidEmail
        }

        try await ensureUsernameAvailable(sanitizedUsername, for: user.uid)

        if sanitizedEmail != user.email?.lowercased() {
            try await user.updateEmail(to: sanitizedEmail)
            try await user.reload()
        }

        try await userDocument(uid: user.uid).setData([
            "username": sanitizedUsername,
            "searchUsername": sanitizedUsername.lowercased(),
            "email": sanitizedEmail,
            "bio": sanitizedBio,
            "location": sanitizedLocation,
            "updatedAt": FieldValue.serverTimestamp()
        ], merge: true)

        return try await fetchProfile(uid: user.uid, authEmail: user.email)
    }

    private func ensureUsernameAvailable(_ username: String, for uid: String) async throws {
        let snapshot = try await db.collection("users")
            .whereField("searchUsername", isEqualTo: username.lowercased())
            .limit(to: 2)
            .getDocuments()

        let isTakenByAnotherUser = snapshot.documents.contains { document in
            document.documentID != uid
        }

        if isTakenByAnotherUser {
            throw ProfileServiceError.usernameTaken
        }
    }

    private func userDocument(uid: String) -> DocumentReference {
        db.collection("users").document(uid)
    }

    private func trimmedNonEmpty(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else {
            return nil
        }

        return trimmed
    }

    private func intValue(from value: Any?) -> Int {
        if let int = value as? Int {
            return int
        }

        if let number = value as? NSNumber {
            return number.intValue
        }

        return 0
    }
}

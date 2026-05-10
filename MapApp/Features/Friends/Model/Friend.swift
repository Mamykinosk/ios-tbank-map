import Foundation
import FirebaseFirestore

struct Friend: Identifiable, Hashable {
    let id: String
    var username: String
    var email: String
    var avatarURL: String?
    var createdAt: Date

    init(
        id: String,
        username: String,
        email: String,
        avatarURL: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.avatarURL = avatarURL
        self.createdAt = createdAt
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
        self.email = email
        self.avatarURL = data["avatarURL"] as? String

        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }

    init(user: AppUser) {
        self.id = user.id
        self.username = user.username
        self.email = user.email
        self.avatarURL = user.avatarURL
        self.createdAt = Date()
    }

    var firestoreData: [String: Any] {
        [
            "userId": id,
            "username": username,
            "email": email,
            "avatarURL": avatarURL as Any,
            "createdAt": FieldValue.serverTimestamp()
        ]
    }
}

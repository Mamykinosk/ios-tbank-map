import Foundation
import FirebaseFirestore

struct FriendUser: Identifiable, Hashable {
    let id: String
    var username: String
    var email: String

    init(id: String, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }

    init?(id: String, data: [String: Any]) {
        let email = data["email"] as? String ?? ""
        let username = data["username"] as? String ?? email.components(separatedBy: "@").first ?? "User"

        guard !email.isEmpty || !username.isEmpty else {
            return nil
        }

        self.id = id
        self.username = username
        self.email = email
    }
}

struct FriendRequest: Identifiable, Hashable {
    let id: String
    let senderId: String
    let receiverId: String
    let createdAt: Date
    var sender: FriendUser?

    init(
        id: String,
        senderId: String,
        receiverId: String,
        createdAt: Date,
        sender: FriendUser? = nil
    ) {
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.createdAt = createdAt
        self.sender = sender
    }

    init?(id: String, data: [String: Any]) {
        guard
            let senderId = data["senderId"] as? String,
            let receiverId = data["receiverId"] as? String
        else {
            return nil
        }

        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId

        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }

        self.sender = nil
    }
}

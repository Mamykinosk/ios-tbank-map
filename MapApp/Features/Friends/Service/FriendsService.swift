import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FriendService {
    static let shared = FriendService()

    private let db = Firestore.firestore()

    private init() {}

    func searchUsers(query: String, currentUserId: String) async throws -> [FriendUser] {
        let trimmedQuery = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !trimmedQuery.isEmpty else {
            return []
        }

        let snapshot = try await getDocuments(from: db.collection("users"))

        return snapshot.documents
            .compactMap { document in
                FriendUser(id: document.documentID, data: document.data())
            }
            .filter { user in
                user.id != currentUserId &&
                (
                    user.username.lowercased().contains(trimmedQuery) ||
                    user.email.lowercased().contains(trimmedQuery)
                )
            }
            .sorted {
                $0.username.localizedCaseInsensitiveCompare($1.username) == .orderedAscending
            }
    }

    func listenFriends(
        userId: String,
        completion: @escaping (Result<[FriendUser], Error>) -> Void
    ) -> ListenerRegistration {
        db.collection("friends")
            .document(userId)
            .collection("list")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error {
                    completion(.failure(error))
                    return
                }

                let friendIds = snapshot?.documents.compactMap { document in
                    document.data()["friendId"] as? String
                } ?? []

                Task {
                    do {
                        let users = try await self.fetchUsers(ids: friendIds)
                        completion(.success(users))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
    }

    func listenIncomingRequests(
        userId: String,
        completion: @escaping (Result<[FriendRequest], Error>) -> Void
    ) -> ListenerRegistration {
        db.collection("friends")
            .document(userId)
            .collection("requests")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }

                if let error {
                    completion(.failure(error))
                    return
                }

                var requests = snapshot?.documents.compactMap { document in
                    FriendRequest(id: document.documentID, data: document.data())
                } ?? []

                Task {
                    do {
                        for index in requests.indices {
                            requests[index].sender = try await self.fetchUser(id: requests[index].senderId)
                        }

                        completion(.success(requests))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
    }

    func listenOutgoingRequestIds(
        userId: String,
        completion: @escaping (Result<Set<String>, Error>) -> Void
    ) -> ListenerRegistration {
        db.collection("friends")
            .document(userId)
            .collection("outgoing")
            .addSnapshotListener { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                let receiverIds = Set(
                    snapshot?.documents.compactMap { document in
                        document.data()["receiverId"] as? String
                    } ?? []
                )

                completion(.success(receiverIds))
            }
    }
    
    func isFriendRequestAlreadySent(to receiverId: String) async throws -> Bool {
        guard let senderId = Auth.auth().currentUser?.uid else {
            throw FriendServiceError.userNotAuthenticated
        }
        
        guard senderId != receiverId else {
            throw FriendServiceError.cannotAddYourself
        }
        
        let outgoingDocument = db.collection("friends")
            .document(senderId)
            .collection("outgoing")
            .document(receiverId)
        
        let existingOutgoing = try await getDocument(outgoingDocument)
        
        if existingOutgoing.exists { return true }
        else { return false }
    }

    func sendFriendRequest(to receiverId: String) async throws {
        guard let senderId = Auth.auth().currentUser?.uid else {
            throw FriendServiceError.userNotAuthenticated
        }

        guard senderId != receiverId else {
            throw FriendServiceError.cannotAddYourself
        }

        let outgoingDocument = db.collection("friends")
            .document(senderId)
            .collection("outgoing")
            .document(receiverId)

        let existingOutgoing = try await getDocument(outgoingDocument)

        if existingOutgoing.exists {
            throw FriendServiceError.requestAlreadySent
        }

        let incomingRequestDocument = db.collection("friends")
            .document(receiverId)
            .collection("requests")
            .document(senderId)

        let now = Timestamp(date: Date())

        let incomingRequestData: [String: Any] = [
            "senderId": senderId,
            "receiverId": receiverId,
            "createdAt": now
        ]

        let outgoingRequestData: [String: Any] = [
            "senderId": senderId,
            "receiverId": receiverId,
            "createdAt": now
        ]

        let batch = db.batch()
        batch.setData(incomingRequestData, forDocument: incomingRequestDocument)
        batch.setData(outgoingRequestData, forDocument: outgoingDocument)

        try await commit(batch)
    }

    func acceptRequest(_ request: FriendRequest) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw FriendServiceError.userNotAuthenticated
        }

        guard request.receiverId == currentUserId else {
            throw FriendServiceError.permissionDenied
        }

        let senderId = request.senderId
        let receiverId = request.receiverId
        let now = Timestamp(date: Date())

        let receiverFriendDocument = db.collection("friends")
            .document(receiverId)
            .collection("list")
            .document(senderId)

        let senderFriendDocument = db.collection("friends")
            .document(senderId)
            .collection("list")
            .document(receiverId)

        let incomingRequestDocument = db.collection("friends")
            .document(receiverId)
            .collection("requests")
            .document(senderId)

        let outgoingRequestDocument = db.collection("friends")
            .document(senderId)
            .collection("outgoing")
            .document(receiverId)

        let batch = db.batch()

        batch.setData(
            [
                "friendId": senderId,
                "createdAt": now
            ],
            forDocument: receiverFriendDocument
        )

        batch.setData(
            [
                "friendId": receiverId,
                "createdAt": now
            ],
            forDocument: senderFriendDocument
        )

        batch.deleteDocument(incomingRequestDocument)
        batch.deleteDocument(outgoingRequestDocument)

        try await commit(batch)
    }

    func rejectRequest(_ request: FriendRequest) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw FriendServiceError.userNotAuthenticated
        }

        guard request.receiverId == currentUserId else {
            throw FriendServiceError.permissionDenied
        }

        let incomingRequestDocument = db.collection("friends")
            .document(request.receiverId)
            .collection("requests")
            .document(request.senderId)

        let outgoingRequestDocument = db.collection("friends")
            .document(request.senderId)
            .collection("outgoing")
            .document(request.receiverId)

        let batch = db.batch()
        batch.deleteDocument(incomingRequestDocument)
        batch.deleteDocument(outgoingRequestDocument)

        try await commit(batch)
    }

    func removeFriend(_ friend: FriendUser) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw FriendServiceError.userNotAuthenticated
        }

        let myFriendDocument = db.collection("friends")
            .document(currentUserId)
            .collection("list")
            .document(friend.id)

        let theirFriendDocument = db.collection("friends")
            .document(friend.id)
            .collection("list")
            .document(currentUserId)

        let batch = db.batch()
        batch.deleteDocument(myFriendDocument)
        batch.deleteDocument(theirFriendDocument)

        try await commit(batch)
    }

    private func fetchUsers(ids: [String]) async throws -> [FriendUser] {
        var users: [FriendUser] = []

        for id in ids {
            if let user = try await fetchUser(id: id) {
                users.append(user)
            }
        }

        return users.sorted {
            $0.username.localizedCaseInsensitiveCompare($1.username) == .orderedAscending
        }
    }

    private func fetchUser(id: String) async throws -> FriendUser? {
        let document = db.collection("users").document(id)
        let snapshot = try await getDocument(document)

        guard snapshot.exists else {
            return nil
        }

        return FriendUser(id: snapshot.documentID, data: snapshot.data() ?? [:])
    }

    private func getDocuments(from query: Query) async throws -> QuerySnapshot {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<QuerySnapshot, Error>) in
            query.getDocuments { snapshot, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let snapshot {
                    continuation.resume(returning: snapshot)
                } else {
                    continuation.resume(throwing: FriendServiceError.unknown)
                }
            }
        }
    }

    private func getDocument(_ document: DocumentReference) async throws -> DocumentSnapshot {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<DocumentSnapshot, Error>) in
            document.getDocument { snapshot, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let snapshot {
                    continuation.resume(returning: snapshot)
                } else {
                    continuation.resume(throwing: FriendServiceError.unknown)
                }
            }
        }
    }

    private func commit(_ batch: WriteBatch) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            batch.commit { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}

enum FriendServiceError: LocalizedError {
    case userNotAuthenticated
    case cannotAddYourself
    case requestAlreadySent
    case permissionDenied
    case unknown

    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return L10n.Message.userNotAuthenticated
        case .cannotAddYourself:
            return L10n.Message.cannotAddYourself
        case .requestAlreadySent:
            return L10n.Message.friendRequestAlreadySent
        case .permissionDenied:
            return L10n.Message.noPermission
        case .unknown:
            return L10n.Message.unknownFriendsServiceError
        }
    }
}

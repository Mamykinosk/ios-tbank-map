import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
import CoreLocation

final class MemoryService {
    static let shared = MemoryService()

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    private init() {}

    func listenMemories(
        userId: String,
        completion: @escaping (Result<[Memory], Error>) -> Void
    ) -> ListenerRegistration {
        db.collection("memories")
            .whereField("userId", isEqualTo: userId)
            .order(by: "visitDate", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                let memories = snapshot?.documents.compactMap { document in
                    Memory(id: document.documentID, data: document.data())
                } ?? []

                completion(.success(memories))
            }
    }

    func createMemory(from draft: MemoryDraft) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw MemoryServiceError.userNotAuthenticated
        }

        guard let coordinate = draft.coordinate else {
            throw MemoryServiceError.missingCoordinate
        }

        let resolvedLocation = await ReverseGeocoder.shared.resolve(coordinate: coordinate)

        let city = resolvedLocation.city
        let country = resolvedLocation.country

        let automaticPlaceName = resolvedLocation.automaticPlaceName.isEmpty
            ? draft.normalizedTitle
            : resolvedLocation.automaticPlaceName

        let uploadedPhotoURLs = try await uploadImages(
            draft.newImages,
            userId: currentUserId
        )

        let photoURLs = draft.existingPhotoURLs + uploadedPhotoURLs

        let document = db.collection("memories").document()

        let memory = Memory(
            id: document.documentID,
            userId: currentUserId,
            title: draft.normalizedTitle,
            placeName: automaticPlaceName,
            city: city,
            country: country,
            story: draft.normalizedStory,
            visitDate: draft.visitDate,
            coordinate: coordinate,
            photoURLs: photoURLs,
            createdAt: Date(),
            updatedAt: Date()
        )

        try await setData(memory.firestoreData, for: document)
    }

    func updateMemory(_ memory: Memory, with draft: MemoryDraft) async throws {
        _ = try await updateMemoryAndReturn(memory, with: draft)
    }

    func updateMemoryAndReturn(_ memory: Memory, with draft: MemoryDraft) async throws -> Memory {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw MemoryServiceError.userNotAuthenticated
        }

        guard memory.userId == currentUserId else {
            throw MemoryServiceError.permissionDenied
        }

        let coordinate = draft.coordinate ?? memory.coordinate
        let resolvedLocation = await ReverseGeocoder.shared.resolve(coordinate: coordinate)

        let city = resolvedLocation.city.isEmpty
            ? memory.city.trimmingCharacters(in: .whitespacesAndNewlines)
            : resolvedLocation.city

        let country = resolvedLocation.country.isEmpty
            ? memory.country.trimmingCharacters(in: .whitespacesAndNewlines)
            : resolvedLocation.country

        let automaticPlaceName: String
        if !country.isEmpty || !city.isEmpty {
            automaticPlaceName = [country, city]
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                .joined(separator: ", ")
        } else if !memory.placeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            automaticPlaceName = memory.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            automaticPlaceName = draft.normalizedTitle
        }

        let uploadedPhotoURLs = try await uploadImages(
            draft.newImages,
            userId: currentUserId
        )

        let photoURLs = draft.existingPhotoURLs + uploadedPhotoURLs

        let updatedMemory = Memory(
            id: memory.id,
            userId: currentUserId,
            title: draft.normalizedTitle,
            placeName: automaticPlaceName,
            city: city,
            country: country,
            story: draft.normalizedStory,
            visitDate: draft.visitDate,
            coordinate: coordinate,
            photoURLs: photoURLs,
            createdAt: memory.createdAt,
            updatedAt: Date()
        )

        let document = db.collection("memories").document(memory.id)
        try await updateData(updatedMemory.firestoreData, for: document)

        return updatedMemory
    }

    func deleteMemory(_ memory: Memory) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw MemoryServiceError.userNotAuthenticated
        }

        guard memory.userId == currentUserId else {
            throw MemoryServiceError.permissionDenied
        }

        let document = db.collection("memories").document(memory.id)
        try await deleteData(for: document)
    }

    private func uploadImages(_ images: [UIImage], userId: String) async throws -> [String] {
        guard !images.isEmpty else {
            return []
        }

        var urls: [String] = []

        for image in images {
            guard let data = image.jpegData(compressionQuality: 0.82) else {
                continue
            }

            let fileName = "\(UUID().uuidString).jpg"
            let path = "memories/\(userId)/\(fileName)"
            let reference = storage.reference().child(path)

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            _ = try await putData(data, metadata: metadata, reference: reference)

            let url = try await downloadURL(for: reference)
            urls.append(url.absoluteString)
        }

        return urls
    }

    private func setData(_ data: [String: Any], for document: DocumentReference) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            document.setData(data) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func updateData(_ data: [String: Any], for document: DocumentReference) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            document.updateData(data) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func deleteData(for document: DocumentReference) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            document.delete { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func putData(
        _ data: Data,
        metadata: StorageMetadata,
        reference: StorageReference
    ) async throws -> StorageMetadata {
        try await withCheckedThrowingContinuation { continuation in
            reference.putData(data, metadata: metadata) { metadata, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let metadata {
                    continuation.resume(returning: metadata)
                } else {
                    continuation.resume(throwing: MemoryServiceError.unknown)
                }
            }
        }
    }

    private func downloadURL(for reference: StorageReference) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            reference.downloadURL { url, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: MemoryServiceError.unknown)
                }
            }
        }
    }
}

enum MemoryServiceError: LocalizedError {
    case userNotAuthenticated
    case missingCoordinate
    case permissionDenied
    case unknown

    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return L10n.Error.userNotAuthenticated
        case .missingCoordinate:
            return L10n.Memories.Error.coordinateMissing
        case .permissionDenied:
            return L10n.Error.noPermission
        case .unknown:
            return L10n.Memories.Error.unknown
        }
    }
}

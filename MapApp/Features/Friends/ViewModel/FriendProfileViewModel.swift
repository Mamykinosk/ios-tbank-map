import Foundation
import Observation
import FirebaseFirestore

@MainActor
@Observable
final class FriendProfileViewModel {
    let friend: FriendUser
    
    var isFriend = true
    var isAlreadySent = false

    var memories: [Memory] = []

    var isLoading = false
    var isFriendMapPresented = false
    var errorMessage: String?
    var successMessage: String?

    private var memoriesListener: ListenerRegistration?

    init(friend: FriendUser) {
        self.friend = friend
    }

    var memoriesCount: Int {
        memories.count
    }

    var countriesCount: Int {
        uniqueCount {
            $0.country
        }
    }

    var citiesCount: Int {
        uniqueCount {
            $0.city
        }
    }

    func startListening() {
        stopListening()

        isLoading = true
        errorMessage = nil

        memoriesListener = MemoryService.shared.listenMemories(userId: friend.id) { [weak self] result in
            Task { @MainActor in
                guard let self else { return }

                self.isLoading = false

                switch result {
                case .success(let memories):
                    self.memories = memories

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func stopListening() {
        memoriesListener?.remove()
        memoriesListener = nil
    }

    func showFriendMap() {
        isFriendMapPresented = true
    }

    func sendRequest() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                try await FriendService.shared.sendFriendRequest(to: friend.id)

                await MainActor.run {
                    self.isLoading = false
                    self.successMessage = L10n.Message.friendRequestSent
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func isFriendRequestAlreadySent() async {
        isLoading = true
        
        Task {
            do {
                self.isAlreadySent = try await FriendService.shared.isFriendRequestAlreadySent(to: friend.id)
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
            catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func removeFriend() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                try await FriendService.shared.removeFriend(friend)
                isFriend = false

                await MainActor.run {
                    self.isLoading = false
                    self.successMessage = L10n.Message.friendRemoved
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func uniqueCount(_ keyPath: (Memory) -> String) -> Int {
        Set(
            memories
                .map { keyPath($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        ).count
    }
}

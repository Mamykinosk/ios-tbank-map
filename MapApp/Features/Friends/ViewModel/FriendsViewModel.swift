import Foundation
import FirebaseFirestore
import Observation

@MainActor
@Observable
final class FriendsViewModel {
    var friends: [FriendUser] = []
    var incomingRequests: [FriendRequest] = []
    var outgoingRequestIds: Set<String> = []
    var searchFriendResults: [FriendUser] = []
    var searchUserResults: [FriendUser] = []
    var incomingRequestsIds: Set<String> = []
    
    var searchUserText = ""
    var searchFriendText = ""
    var selectedFriendForProfile: FriendUser?
    
    var isSearching = false
    var isLoading = false
    var errorMessage: String?
    var successMessage: String?
    
    var isSearchPresented = false
    
    private var friendsListener: ListenerRegistration?
    private var incomingRequestsListener: ListenerRegistration?
    private var outgoingRequestsListener: ListenerRegistration?
    private var currentUserId: String?
    
    func start(currentUserId: String) {
        stop()
        
        self.currentUserId = currentUserId
        errorMessage = nil
        successMessage = nil
        
        friendsListener = FriendService.shared.listenFriends(userId: currentUserId) { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                
                switch result {
                case .success(let friends):
                    self.friends = friends
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        
        incomingRequestsListener = FriendService.shared.listenIncomingRequests(userId: currentUserId) { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                
                switch result {
                case .success(let requests):
                    self.incomingRequests = requests
                    self.incomingRequestsIds = self.getIdSendersRequests(requests: requests)
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        
        outgoingRequestsListener = FriendService.shared.listenOutgoingRequestIds(userId: currentUserId) { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                
                switch result {
                case .success(let ids):
                    self.outgoingRequestIds = ids
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func stop() {
        friendsListener?.remove()
        incomingRequestsListener?.remove()
        outgoingRequestsListener?.remove()
        
        friendsListener = nil
        incomingRequestsListener = nil
        outgoingRequestsListener = nil
    }
    
    func reset() {
        stop()
        
        friends = []
        incomingRequests = []
        outgoingRequestIds = []
        searchUserResults = []
        searchUserText = ""
        searchFriendResults = []
        searchFriendText = ""
        selectedFriendForProfile = nil
        
        isSearching = false
        isLoading = false
        errorMessage = nil
        successMessage = nil
        
        currentUserId = nil
    }
    
    func searchFriends() -> [FriendUser] {
        return friends.filter( {$0.username.contains(searchFriendText) || $0.email.contains(searchFriendText)} )
    }
    
    func searchUsers() {
        guard let currentUserId else {
            errorMessage = L10n.Message.userNotAuthenticated
            return
        }
        
        let query = searchUserText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            searchUserResults = []
            return
        }
        
        isSearching = true
        errorMessage = nil
        successMessage = nil
        
        Task {
            do {
                let users = try await FriendService.shared.searchUsers(
                    query: query,
                    currentUserId: currentUserId
                )
                
                await MainActor.run {
                    self.searchUserResults = users
                    self.isSearching = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isSearching = false
                }
            }
        }
    }
    
    func clearUserSearch() {
        searchUserText = ""
        searchUserResults = []
        errorMessage = nil
        successMessage = nil
    }
    
    func clearFriendSearch() {
        searchFriendText = ""
        searchFriendResults = []
        errorMessage = nil
        successMessage = nil
    }
    
    func openProfile(for friend: FriendUser) {
        selectedFriendForProfile = friend
    }
    
    func getIdSendersRequests(requests: [FriendRequest]) -> Set<String> {
        return Set(requests.compactMap { $0.senderId } )
    }

    func sendRequest(to user: FriendUser) {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                try await FriendService.shared.sendFriendRequest(to: user.id)

                await MainActor.run {
                    self.isLoading = false
                    self.successMessage = L10n.Message.friendRequestSent
                    self.outgoingRequestIds.insert(user.id)
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func acceptRequest(_ request: FriendRequest) {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                try await FriendService.shared.acceptRequest(request)

                await MainActor.run {
                    self.isLoading = false
                    self.successMessage = L10n.Message.friendRequestAccepted
                    self.incomingRequests.removeAll { $0.id == request.id }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func rejectRequest(_ request: FriendRequest) {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                try await FriendService.shared.rejectRequest(request)

                await MainActor.run {
                    self.isLoading = false
                    self.successMessage = L10n.Message.friendRequestRejected
                    self.incomingRequests.removeAll { $0.id == request.id }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func removeFriend(_ friend: FriendUser) {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                try await FriendService.shared.removeFriend(friend)

                await MainActor.run {
                    self.isLoading = false
                    self.successMessage = L10n.Message.friendRemoved
                    self.friends.removeAll { $0.id == friend.id }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func isAlreadyFriend(_ user: FriendUser) -> Bool {
        friends.contains { $0.id == user.id }
    }

    func isRequestAlreadySent(to user: FriendUser) -> Bool {
        outgoingRequestIds.contains(user.id)
    }

    func canSendRequest(to user: FriendUser) -> Bool {
        !isAlreadyFriend(user) && !isRequestAlreadySent(to: user)
    }
}

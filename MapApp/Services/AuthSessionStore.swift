import FirebaseAuth
import Observation

@MainActor
@Observable
final class AuthSessionStore {
    nonisolated(unsafe) private let auth = Auth.auth()
    nonisolated(unsafe) private var authStateHandle: AuthStateDidChangeListenerHandle?

    var currentUser: User?

    var isAuthenticated: Bool {
        currentUser != nil
    }

    init() {
        currentUser = auth.currentUser
        authStateHandle = auth.addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            Task { @MainActor in
                self.currentUser = user
            }
        }
    }

    func refreshCurrentUser() async {
        do {
            try await auth.currentUser?.reload()
        } catch {
            // Keep the current auth state if Firebase cannot refresh right now.
        }

        currentUser = auth.currentUser
    }

    deinit {
        if let authStateHandle {
            auth.removeStateDidChangeListener(authStateHandle)
        }
    }
}








import FirebaseAuth
import FirebaseFirestore

final class AuthService {
    static let shared = AuthService()

    private init() {}

    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }

    func register(email: String, password: String, username: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let userId = result.user.uid
        let db = Firestore.firestore()

        do {
            try await db.collection("users").document(userId).setData([
                "username": username,
                "searchUsername": username.lowercased(),
                "email": email,
                "createdAt": FieldValue.serverTimestamp(),
                "stats": [
                    "countries": 0,
                    "cities": 0,
                    "memoriesCount": 0
                ]
            ])
        } catch {
            try? await result.user.delete()
            throw error
        }

        return result.user
    }

    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}

import FirebaseAuth
import Foundation
import Observation

@MainActor
@Observable
final class EditProfileViewModel {
    var username = ""
    var email = ""
    var location = ""
    var bio = ""

    var errorMessage: String?
    var infoMessage: String?
    var isLoading = false

    let bioLimit = 160

    func loadProfile(user: User?) async {
        guard let user else {
            errorMessage = ProfileServiceError.unauthenticated.localizedDescription
            return
        }

        isLoading = true
        errorMessage = nil
        infoMessage = nil

        do {
            let profile = try await ProfileService.shared.fetchProfile(
                uid: user.uid,
                authEmail: user.email
            )
            apply(profile)
        } catch {
            email = user.email ?? ""
            username = user.email?
                .split(separator: "@")
                .first
                .map { String($0).replacingOccurrences(of: ".", with: "_") } ?? ""
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func saveProfile(user: User?) async -> Bool {
        guard let user else {
            errorMessage = ProfileServiceError.unauthenticated.localizedDescription
            return false
        }

        guard validate() else {
            return false
        }

        isLoading = true
        errorMessage = nil
        infoMessage = nil

        do {
            let profile = try await ProfileService.shared.updateProfile(
                user: user,
                username: username,
                email: email,
                bio: bio,
                location: location
            )
            apply(profile)
            infoMessage = "Profile updated."
            isLoading = false
            return true
        } catch {
            errorMessage = mapError(error)
            isLoading = false
            return false
        }
    }

    private func apply(_ profile: UserProfile) {
        username = profile.username
        email = profile.email
        bio = String(profile.bio.prefix(bioLimit))
        location = profile.location
    }

    private func validate() -> Bool {
        errorMessage = nil
        infoMessage = nil

        let sanitizedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let sanitizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard sanitizedUsername.wholeMatch(of: /^[A-Za-z0-9_]{3,30}$/) != nil else {
            errorMessage = ProfileServiceError.invalidUsername.localizedDescription
            return false
        }

        guard sanitizedEmail.wholeMatch(of: /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/) != nil else {
            errorMessage = ProfileServiceError.invalidEmail.localizedDescription
            return false
        }

        if bio.count > bioLimit {
            bio = String(bio.prefix(bioLimit))
        }

        return true
    }

    private func mapError(_ error: Error) -> String {
        if let localizedError = error as? LocalizedError,
           let message = localizedError.errorDescription {
            return message
        }

        let nsError = error as NSError
        guard nsError.domain == AuthErrorDomain,
              let code = AuthErrorCode(rawValue: nsError.code) else {
            return "Unable to update profile. Please try again."
        }

        switch code {
        case .emailAlreadyInUse:
            return "This email is already in use."
        case .invalidEmail:
            return ProfileServiceError.invalidEmail.localizedDescription
        case .requiresRecentLogin:
            return "For security, sign in again before changing your email."
        case .networkError:
            return "Network error. Check your connection and try again."
        default:
            return nsError.localizedDescription
        }
    }
}

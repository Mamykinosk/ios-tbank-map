import Foundation
import Observation
import SwiftUI
import FirebaseAuth

@MainActor
@Observable
final class ProfileViewModel {
    var displayName = L10n.Profile.defaultDisplayName
    var username = L10n.Profile.defaultUsername
    var bio = ""
    var avatarImageName: String?
    var stats: [ProfileStat] = [
        ProfileStat(value: "0", title: L10n.Profile.Stats.countries),
        ProfileStat(value: "0", title: L10n.Profile.Stats.cities),
        ProfileStat(value: "0", title: L10n.Profile.Stats.memories)
    ]

    var isDarkModeEnabled = false
    var errorMessage: String?
    var isLoading = false

    func loadProfile(user: User?) async {
        guard let user else {
            errorMessage = ProfileServiceError.unauthenticated.localizedDescription
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let profile = try await ProfileService.shared.fetchProfile(
                uid: user.uid,
                authEmail: user.email
            )
            apply(profile: profile, displayName: user.displayName)
        } catch {
            errorMessage = error.localizedDescription
            syncAuthProfile(displayName: user.displayName, email: user.email)
        }

        isLoading = false
    }

    func syncAuthProfile(displayName authDisplayName: String?, email: String?) {
        if let authDisplayName = trimmedNonEmpty(authDisplayName) {
            displayName = authDisplayName
        }

        if let emailPrefix = email?.split(separator: "@").first,
           !emailPrefix.isEmpty {
            username = "@" + emailPrefix.lowercased()
        }
    }

    func logout() -> Bool {
        errorMessage = nil

        do {
            try AuthService.shared.signOut()
            return true
        } catch {
            errorMessage = L10n.Profile.Logout.error
            return false
        }
    }

    private func trimmedNonEmpty(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else {
            return nil
        }

        return trimmed
    }

    private func apply(profile: UserProfile, displayName authDisplayName: String?) {
        displayName = trimmedNonEmpty(authDisplayName) ?? profile.username
        username = "@" + profile.username
        bio = profile.bio
        stats = [
            ProfileStat(value: "\(profile.stats.countries)", title: L10n.Profile.Stats.countries),
            ProfileStat(value: "\(profile.stats.cities)", title: L10n.Profile.Stats.cities),
            ProfileStat(value: "\(profile.stats.memoriesCount)", title: L10n.Profile.Stats.memories)
        ]
    }
}

struct ProfileStat: Identifiable, Hashable {
    let id = UUID()
    let value: String
    let title: String

    static func == (lhs: ProfileStat, rhs: ProfileStat) -> Bool {
        lhs.id == rhs.id && lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(value)
    }
}

import Foundation
import Observation
import SwiftUI
import FirebaseAuth

@MainActor
@Observable
final class ProfileViewModel {
    var displayName = String(localized: "profile.defaultDisplayName")
    var username = String(localized: "profile.defaultUsername")
    var bio = ""
    var avatarImageName: String?
    var stats: [ProfileStat] = [
        ProfileStat(value: "0", title: L10n.Profile.Stats.countries),
        ProfileStat(value: "0", title: L10n.Profile.Stats.cities),
        ProfileStat(value: "0", title: L10n.Profile.Stats.memories)
    ]

    var isDarkModeEnabled = false
    var selectedLanguage: ProfileLanguage = .english
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

    func selectLanguage(_ language: ProfileLanguage) {
        selectedLanguage = language
    }

    func logout() -> Bool {
        errorMessage = nil

        do {
            try AuthService.shared.signOut()
            return true
        } catch {
            errorMessage = String(localized: L10n.Profile.logoutError)
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
    let title: LocalizedStringKey

    static func == (lhs: ProfileStat, rhs: ProfileStat) -> Bool {
        lhs.id == rhs.id && lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(value)
    }
}

enum ProfileLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case russian = "Russian"

    var id: String {
        rawValue
    }

    var title: LocalizedStringKey {
        switch self {
        case .english:
            L10n.Profile.Language.english
        case .russian:
            L10n.Profile.Language.russian
        }
    }
}

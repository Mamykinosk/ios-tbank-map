// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation
import Observation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Character count
  internal static func lldLld(_ p1: Int, _ p2: Int) -> String {
    return L10n.tr("Localizable", "%lld / %lld", p1, p2, fallback: "%1$lld / %2$lld")
  }
  /// Settings
  internal static var settings: String { L10n.tr("Localizable", "Settings", fallback: "Settings") }
  /// User
  internal static var userTitle: String { L10n.tr("Localizable", "userTitle", fallback: "User profile") }
  internal enum Auth {
    internal enum Common {
      internal enum Email {
        /// Enter your email
        internal static var placeholder: String { L10n.tr("Localizable", "auth.common.email.placeholder", fallback: "Enter your email") }
        /// Auth - Common
        internal static var title: String { L10n.tr("Localizable", "auth.common.email.title", fallback: "Email") }
      }
      internal enum Password {
        /// Password
        internal static var title: String { L10n.tr("Localizable", "auth.common.password.title", fallback: "Password") }
      }
    }
    internal enum Login {
      /// Forgot password?
      internal static var forgotPassword: String { L10n.tr("Localizable", "auth.login.forgotPassword", fallback: "Forgot password?") }
      /// Don’t have an account?
      internal static var noAnyAccount: String { L10n.tr("Localizable", "auth.login.noAnyAccount", fallback: "Don’t have an account?") }
      /// Or connect with
      internal static var orConnectWith: String { L10n.tr("Localizable", "auth.login.orConnectWith", fallback: "Or connect with") }
      /// Register now
      internal static var registerNow: String { L10n.tr("Localizable", "auth.login.registerNow", fallback: "Register now") }
      /// Sign in to continue your journey.
      internal static var subtitle: String { L10n.tr("Localizable", "auth.login.subtitle", fallback: "Sign in to continue your journey.") }
      /// Auth - Login
      internal static var title: String { L10n.tr("Localizable", "auth.login.title", fallback: "Welcome back") }
      internal enum Login {
        /// Log in
        internal static var action: String { L10n.tr("Localizable", "auth.login.login.action", fallback: "Log in") }
      }
    }
    internal enum Recovery {
      /// Back to sign in
      internal static var backToSingIn: String { L10n.tr("Localizable", "auth.recovery.backToSingIn", fallback: "Back to sign in") }
      /// Enter your email and we’ll send you a reset link.
      internal static var subtitle: String { L10n.tr("Localizable", "auth.recovery.subtitle", fallback: "Enter your email and we’ll send you a reset link.") }
      /// Auth - Recovery
      internal static var title: String { L10n.tr("Localizable", "auth.recovery.title", fallback: "Reset password") }
      internal enum SendResetLink {
        /// Send reset link
        internal static var action: String { L10n.tr("Localizable", "auth.recovery.sendResetLink.action", fallback: "Send reset link") }
      }
    }
    internal enum Register {
      /// Register
      internal static var action: String { L10n.tr("Localizable", "auth.register.action", fallback: "Register") }
      /// Already have an account?
      internal static var alreadyHaveAccount: String { L10n.tr("Localizable", "auth.register.alreadyHaveAccount", fallback: "Already have an account?") }
      /// Log in now
      internal static var loginNow: String { L10n.tr("Localizable", "auth.register.loginNow", fallback: "Log in now") }
      /// Join us and start collecting your memories.
      internal static var subtitle: String { L10n.tr("Localizable", "auth.register.subtitle", fallback: "Join us and start collecting your memories.") }
      /// Auth - Register
      internal static var title: String { L10n.tr("Localizable", "auth.register.title", fallback: "Create account") }
      internal enum ConfirmPassword {
        /// Confirm password
        internal static var title: String { L10n.tr("Localizable", "auth.register.confirmPassword.title", fallback: "Confirm password") }
      }
      internal enum Username {
        /// Enter your username
        internal static var placeholder: String { L10n.tr("Localizable", "auth.register.username.placeholder", fallback: "Enter your username") }
        /// Username
        internal static var title: String { L10n.tr("Localizable", "auth.register.username.title", fallback: "Username") }
      }
    }
  }
  internal enum Common {
    /// Add
    internal static var add: String { L10n.tr("Localizable", "common.add", fallback: "Add") }
    /// Common
    internal static var cancel: String { L10n.tr("Localizable", "common.cancel", fallback: "Cancel") }
    /// Clear
    internal static var clear: String { L10n.tr("Localizable", "common.clear", fallback: "Clear") }
    /// Delete
    internal static var delete: String { L10n.tr("Localizable", "common.delete", fallback: "Delete") }
    /// Done
    internal static var done: String { L10n.tr("Localizable", "common.done", fallback: "Done") }
    /// Edit
    internal static var edit: String { L10n.tr("Localizable", "common.edit", fallback: "Edit") }
    /// Error
    internal static var error: String { L10n.tr("Localizable", "common.error", fallback: "Error") }
    /// Loading...
    internal static var loading: String { L10n.tr("Localizable", "common.loading", fallback: "Loading...") }
    /// Save
    internal static var save: String { L10n.tr("Localizable", "common.save", fallback: "Save") }
    /// Search
    internal static var search: String { L10n.tr("Localizable", "common.search", fallback: "Search") }
  }
  internal enum EditProfile {
    /// Back
    internal static var back: String { L10n.tr("Localizable", "editProfile.back", fallback: "Back") }
    /// Change profile picture
    internal static var changeProfilePicture: String { L10n.tr("Localizable", "editProfile.changeProfilePicture", fallback: "Change profile picture") }
    /// Personal Identity
    internal static var personalIdentity: String { L10n.tr("Localizable", "editProfile.personalIdentity", fallback: "Personal Identity") }
    /// Settings
    internal static var settings: String { L10n.tr("Localizable", "editProfile.settings", fallback: "Settings") }
    /// Edit Profile
    internal static var title: String { L10n.tr("Localizable", "editProfile.title", fallback: "Edit Profile") }
    internal enum AccountPrivacy {
      /// Manage your data visibility and account permanence.
      internal static var subtitle: String { L10n.tr("Localizable", "editProfile.accountPrivacy.subtitle", fallback: "Manage your data visibility and account permanence.") }
      /// Account Privacy
      internal static var title: String { L10n.tr("Localizable", "editProfile.accountPrivacy.title", fallback: "Account Privacy") }
    }
    internal enum Bio {
      /// Share your journey...
      internal static var placeholder: String { L10n.tr("Localizable", "editProfile.bio.placeholder", fallback: "Share your journey...") }
      /// Bio
      internal static var title: String { L10n.tr("Localizable", "editProfile.bio.title", fallback: "Bio") }
    }
    internal enum DeactivateAccount {
      /// Deactivate Account
      internal static var action: String { L10n.tr("Localizable", "editProfile.deactivateAccount.action", fallback: "Deactivate Account") }
    }
    internal enum Email {
      /// Email Address
      internal static var title: String { L10n.tr("Localizable", "editProfile.email.title", fallback: "Email Address") }
    }
    internal enum Error {
      /// This email is already in use.
      internal static var emailInUse: String { L10n.tr("Localizable", "editProfile.error.emailInUse", fallback: "This email is already in use.") }
      /// Network error. Check your connection and try again.
      internal static var network: String { L10n.tr("Localizable", "editProfile.error.network", fallback: "Network error. Check your connection and try again.") }
      /// For security, sign in again before changing your email.
      internal static var requiresRecentLogin: String { L10n.tr("Localizable", "editProfile.error.requiresRecentLogin", fallback: "For security, sign in again before changing your email.") }
      /// Unable to update profile. Please try again.
      internal static var updateFailed: String { L10n.tr("Localizable", "editProfile.error.updateFailed", fallback: "Unable to update profile. Please try again.") }
    }
    internal enum Location {
      /// Lisbon, Portugal
      internal static var placeholder: String { L10n.tr("Localizable", "editProfile.location.placeholder", fallback: "Lisbon, Portugal") }
      /// Location
      internal static var title: String { L10n.tr("Localizable", "editProfile.location.title", fallback: "Location") }
    }
    internal enum Message {
      /// Profile updated.
      internal static var profileUpdated: String { L10n.tr("Localizable", "editProfile.message.profileUpdated", fallback: "Profile updated.") }
    }
    internal enum SaveChanges {
      /// Save Changes
      internal static var action: String { L10n.tr("Localizable", "editProfile.saveChanges.action", fallback: "Save Changes") }
    }
    internal enum Username {
      /// Only English letters, numbers and underscores allowed.
      internal static var helper: String { L10n.tr("Localizable", "editProfile.username.helper", fallback: "Only English letters, numbers and underscores allowed.") }
      /// Username
      internal static var title: String { L10n.tr("Localizable", "editProfile.username.title", fallback: "Username") }
    }
  }
  internal enum Error {
    /// You don’t have permission to do this
    internal static var noPermission: String { L10n.tr("Localizable", "error.noPermission", fallback: "You don’t have permission to do this") }
    /// Errors
    internal static var userNotAuthenticated: String { L10n.tr("Localizable", "error.userNotAuthenticated", fallback: "User is not authenticated") }
  }
  internal enum Friends {
    /// Accept request
    internal static var accept: String { L10n.tr("Localizable", "friends.accept", fallback: "Accept request") }
    /// Add friend
    internal static var addFriend: String { L10n.tr("Localizable", "friends.addFriend", fallback: "Add friend") }
    /// All friends
    internal static var allFriends: String { L10n.tr("Localizable", "friends.allFriends", fallback: "All friends") }
    /// Request already sent
    internal static var alreadyAdded: String { L10n.tr("Localizable", "friends.alreadyAdded", fallback: "Request already sent") }
    /// Cities
    internal static var cities: String { L10n.tr("Localizable", "friends.cities", fallback: "Cities") }
    /// Countries
    internal static var countries: String { L10n.tr("Localizable", "friends.countries", fallback: "Countries") }
    /// No friends yet
    internal static var emptyFriends: String { L10n.tr("Localizable", "friends.emptyFriends", fallback: "No friends yet") }
    /// Find people and add them to see their travel memories.
    internal static var emptyFriendsHint: String { L10n.tr("Localizable", "friends.emptyFriendsHint", fallback: "Find people and add them to see their travel memories.") }
    /// No friends yet
    internal static var emptyFriendsTitle: String { L10n.tr("Localizable", "friends.emptyFriendsTitle", fallback: "No friends yet") }
    /// This user has no memories on the map yet
    internal static var emptyUserMap: String { L10n.tr("Localizable", "friends.emptyUserMap", fallback: "This user has no memories on the map yet") }
    /// Friend
    internal static var friend: String { L10n.tr("Localizable", "friends.friend", fallback: "Friend") }
    /// Friend request
    internal static var friendRequest: String { L10n.tr("Localizable", "friends.friendRequest", fallback: "Friend request") }
    /// Memories
    internal static var memories: String { L10n.tr("Localizable", "friends.memories", fallback: "Memories") }
    /// No users found
    internal static var noUsersFound: String { L10n.tr("Localizable", "friends.noUsersFound", fallback: "No users found") }
    /// Reject request
    internal static var reject: String { L10n.tr("Localizable", "friends.reject", fallback: "Reject request") }
    /// Remove this friend?
    internal static var removeConfirmation: String { L10n.tr("Localizable", "friends.removeConfirmation", fallback: "Remove this friend?") }
    /// Remove friend
    internal static var removeFriend: String { L10n.tr("Localizable", "friends.removeFriend", fallback: "Remove friend") }
    /// Requests
    internal static var requests: String { L10n.tr("Localizable", "friends.requests", fallback: "Requests") }
    /// Sent
    internal static var sent: String { L10n.tr("Localizable", "friends.sent", fallback: "Sent") }
    /// Show map
    internal static var showMap: String { L10n.tr("Localizable", "friends.showMap", fallback: "Show map") }
    /// Social
    internal static var social: String { L10n.tr("Localizable", "friends.social", fallback: "Social") }
    /// Friends
    internal static var title: String { L10n.tr("Localizable", "friends.title", fallback: "Friends") }
    /// Unknown user
    internal static var unknownUser: String { L10n.tr("Localizable", "friends.unknownUser", fallback: "Unknown user") }
    /// User map
    internal static var userMap: String { L10n.tr("Localizable", "friends.userMap", fallback: "User map") }
    /// Your friends
    internal static var yourFriends: String { L10n.tr("Localizable", "friends.yourFriends", fallback: "Your friends") }
    internal enum Error {
      /// You are already friends
      internal static var alreadyFriends: String { L10n.tr("Localizable", "friends.error.alreadyFriends", fallback: "You are already friends") }
      /// You can’t add yourself as a friend
      internal static var cannotAddYourself: String { L10n.tr("Localizable", "friends.error.cannotAddYourself", fallback: "You can’t add yourself as a friend") }
      /// Friend request already sent
      internal static var requestAlreadySent: String { L10n.tr("Localizable", "friends.error.requestAlreadySent", fallback: "Friend request already sent") }
      /// Something went wrong with friends service
      internal static var unknown: String { L10n.tr("Localizable", "friends.error.unknown", fallback: "Something went wrong with friends service") }
    }
    internal enum Message {
      /// Friend request accepted
      internal static var accepted: String { L10n.tr("Localizable", "friends.message.accepted", fallback: "Friend request accepted") }
      /// Friend request rejected
      internal static var rejected: String { L10n.tr("Localizable", "friends.message.rejected", fallback: "Friend request rejected") }
      /// Friend removed
      internal static var removed: String { L10n.tr("Localizable", "friends.message.removed", fallback: "Friend removed") }
      /// Messages
      internal static var requestSent: String { L10n.tr("Localizable", "friends.message.requestSent", fallback: "Friend request sent") }
    }
    internal enum Profile {
      /// Friend profile
      internal static var title: String { L10n.tr("Localizable", "friends.profile.title", fallback: "Friend profile") }
    }
    internal enum Search {
      /// Search friends
      internal static var placeholder: String { L10n.tr("Localizable", "friends.search.placeholder", fallback: "Search friends") }
    }
  }
  internal enum Logged {
    internal enum TabBar {
      /// Feed
      internal static var feed: String { L10n.tr("Localizable", "logged.tabBar.feed", fallback: "Feed") }
      /// Friends
      internal static var friends: String { L10n.tr("Localizable", "logged.tabBar.friends", fallback: "Friends") }
      /// Tab bar
      internal static var map: String { L10n.tr("Localizable", "logged.tabBar.map", fallback: "Map") }
      /// Profile
      internal static var profile: String { L10n.tr("Localizable", "logged.tabBar.profile", fallback: "Profile") }
    }
  }
  internal enum Main {
    /// Email
    internal static var email: String { L10n.tr("Localizable", "main.email", fallback: "Email") }
    /// Not found
    internal static var notFound: String { L10n.tr("Localizable", "main.notFound", fallback: "Not found") }
    /// Not specified
    internal static var notSpecified: String { L10n.tr("Localizable", "main.notSpecified", fallback: "Not specified") }
    /// Sign out
    internal static var signOut: String { L10n.tr("Localizable", "main.signOut", fallback: "Sign out") }
    /// UID
    internal static var uid: String { L10n.tr("Localizable", "main.uid", fallback: "UID") }
    internal enum SignedIn {
      /// Main
      internal static var title: String { L10n.tr("Localizable", "main.signedIn.title", fallback: "Signed in") }
    }
  }
  internal enum Memories {
    /// Add
    internal static var add: String { L10n.tr("Localizable", "memories.add", fallback: "Add") }
    /// Add photos
    internal static var addPhotos: String { L10n.tr("Localizable", "memories.addPhotos", fallback: "Add photos") }
    /// Memories
    internal static var appTitle: String { L10n.tr("Localizable", "memories.appTitle", fallback: "Memories") }
    /// Discard this memory?
    internal static var cancelAddConfirmation: String { L10n.tr("Localizable", "memories.cancelAddConfirmation", fallback: "Discard this memory?") }
    /// Discard changes?
    internal static var cancelEditConfirmation: String { L10n.tr("Localizable", "memories.cancelEditConfirmation", fallback: "Discard changes?") }
    /// Capture
    internal static var capture: String { L10n.tr("Localizable", "memories.capture", fallback: "Capture") }
    /// Choose location
    internal static var chooseLocation: String { L10n.tr("Localizable", "memories.chooseLocation", fallback: "Choose location") }
    /// No story yet
    internal static var defaultPreviewSubtitle: String { L10n.tr("Localizable", "memories.defaultPreviewSubtitle", fallback: "No story yet") }
    /// Untitled memory
    internal static var defaultPreviewTitle: String { L10n.tr("Localizable", "memories.defaultPreviewTitle", fallback: "Untitled memory") }
    /// This memory will be permanently deleted.
    internal static var deleteConfirmation: String { L10n.tr("Localizable", "memories.deleteConfirmation", fallback: "This memory will be permanently deleted.") }
    /// Delete marker
    internal static var deleteMarker: String { L10n.tr("Localizable", "memories.deleteMarker", fallback: "Delete marker") }
    /// Delete permanently
    internal static var deletePermanently: String { L10n.tr("Localizable", "memories.deletePermanently", fallback: "Delete permanently") }
    /// Edit marker
    internal static var editMarkerTitle: String { L10n.tr("Localizable", "memories.editMarkerTitle", fallback: "Edit marker") }
    /// Edit memory
    internal static var editTitle: String { L10n.tr("Localizable", "memories.editTitle", fallback: "Edit memory") }
    /// No memories yet
    internal static var emptyFeed: String { L10n.tr("Localizable", "memories.emptyFeed", fallback: "No memories yet") }
    /// History story
    internal static var historyStory: String { L10n.tr("Localizable", "memories.historyStory", fallback: "History story") }
    /// items
    internal static var items: String { L10n.tr("Localizable", "memories.items", fallback: "items") }
    /// Last summer
    internal static var lastSummer: String { L10n.tr("Localizable", "memories.lastSummer", fallback: "Last summer") }
    /// Long press on the map to choose a location
    internal static var longPressHint: String { L10n.tr("Localizable", "memories.longPressHint", fallback: "Long press on the map to choose a location") }
    /// Memory
    internal static var memoryTitle: String { L10n.tr("Localizable", "memories.memoryTitle", fallback: "Memory") }
    /// New memory
    internal static var newMemoryTitle: String { L10n.tr("Localizable", "memories.newMemoryTitle", fallback: "New memory") }
    /// No memories found
    internal static var noMemoriesFound: String { L10n.tr("Localizable", "memories.noMemoriesFound", fallback: "No memories found") }
    /// No story added
    internal static var noStoryAdded: String { L10n.tr("Localizable", "memories.noStoryAdded", fallback: "No story added") }
    /// Photo gallery
    internal static var photoGallery: String { L10n.tr("Localizable", "memories.photoGallery", fallback: "Photo gallery") }
    /// photos
    internal static var photos: String { L10n.tr("Localizable", "memories.photos", fallback: "photos") }
    /// Place name
    internal static var placeName: String { L10n.tr("Localizable", "memories.placeName", fallback: "Place name") }
    /// Enter place name
    internal static var placeNamePlaceholder: String { L10n.tr("Localizable", "memories.placeNamePlaceholder", fallback: "Enter place name") }
    /// Place name is required
    internal static var placeNameRequired: String { L10n.tr("Localizable", "memories.placeNameRequired", fallback: "Place name is required") }
    /// Recent archive
    internal static var recentArchive: String { L10n.tr("Localizable", "memories.recentArchive", fallback: "Recent archive") }
    /// Save changes
    internal static var saveChanges: String { L10n.tr("Localizable", "memories.saveChanges", fallback: "Save changes") }
    /// Save memory
    internal static var saveMemory: String { L10n.tr("Localizable", "memories.saveMemory", fallback: "Save memory") }
    /// Try searching by place, city, country, or story.
    internal static var searchNoResultsHint: String { L10n.tr("Localizable", "memories.searchNoResultsHint", fallback: "Try searching by place, city, country, or story.") }
    /// Stay
    internal static var stay: String { L10n.tr("Localizable", "memories.stay", fallback: "Stay") }
    /// Tell the story behind this memory
    internal static var storyPlaceholder: String { L10n.tr("Localizable", "memories.storyPlaceholder", fallback: "Tell the story behind this memory") }
    /// The story
    internal static var theStory: String { L10n.tr("Localizable", "memories.theStory", fallback: "The story") }
    /// Visit date
    internal static var visitDate: String { L10n.tr("Localizable", "memories.visitDate", fallback: "Visit date") }
    /// Visit date is required
    internal static var visitDateRequired: String { L10n.tr("Localizable", "memories.visitDateRequired", fallback: "Visit date is required") }
    internal enum Error {
      /// Memory location is missing
      internal static var coordinateMissing: String { L10n.tr("Localizable", "memories.error.coordinateMissing", fallback: "Memory location is missing") }
      /// Something went wrong with memories service
      internal static var unknown: String { L10n.tr("Localizable", "memories.error.unknown", fallback: "Something went wrong with memories service") }
    }
    internal enum Feed {
      /// Memories feed
      internal static var title: String { L10n.tr("Localizable", "memories.feed.title", fallback: "Memories feed") }
    }
    internal enum Message {
      /// Memory deleted
      internal static var deleted: String { L10n.tr("Localizable", "memories.message.deleted", fallback: "Memory deleted") }
      /// Memory saved
      internal static var saved: String { L10n.tr("Localizable", "memories.message.saved", fallback: "Memory saved") }
      /// Memory updated
      internal static var updated: String { L10n.tr("Localizable", "memories.message.updated", fallback: "Memory updated") }
    }
    internal enum Search {
      /// Search memories
      internal static var placeholder: String { L10n.tr("Localizable", "memories.search.placeholder", fallback: "Search memories") }
    }
    internal enum SearchMemories {
      /// Search memories
      internal static var title: String { L10n.tr("Localizable", "memories.searchMemories.title", fallback: "Search memories") }
    }
  }
  internal enum Profile {
    /// Profile
    internal static var defaultDisplayName: String { L10n.tr("Localizable", "profile.defaultDisplayName", fallback: "Traveler") }
    /// @traveler
    internal static var defaultUsername: String { L10n.tr("Localizable", "profile.defaultUsername", fallback: "@traveler") }
    internal enum EditProfile {
      /// Edit Profile
      internal static var action: String { L10n.tr("Localizable", "profile.editProfile.action", fallback: "Edit Profile") }
    }
    internal enum Language {
      /// English
      internal static var english: String { L10n.tr("Localizable", "profile.language.english", fallback: "English") }
      /// Russian
      internal static var russian: String { L10n.tr("Localizable", "profile.language.russian", fallback: "Russian") }
    }
    internal enum Logout {
      /// Logout
      internal static var action: String { L10n.tr("Localizable", "profile.logout.action", fallback: "Logout") }
      /// Unable to logout. Please try again.
      internal static var error: String { L10n.tr("Localizable", "profile.logout.error", fallback: "Unable to logout. Please try again.") }
    }
    internal enum Preferences {
      /// Dark Mode
      internal static var darkMode: String { L10n.tr("Localizable", "profile.preferences.darkMode", fallback: "Dark Mode") }
      /// Language
      internal static var language: String { L10n.tr("Localizable", "profile.preferences.language", fallback: "Language") }
      /// Preferences
      internal static var title: String { L10n.tr("Localizable", "profile.preferences.title", fallback: "Preferences") }
    }
    internal enum Stats {
      /// Cities
      internal static var cities: String { L10n.tr("Localizable", "profile.stats.cities", fallback: "Cities") }
      /// Countries
      internal static var countries: String { L10n.tr("Localizable", "profile.stats.countries", fallback: "Countries") }
      /// Memories
      internal static var memories: String { L10n.tr("Localizable", "profile.stats.memories", fallback: "Memories") }
    }
  }
  internal enum Start {
    /// Travel Memorize
    internal static var appTitle: String { L10n.tr("Localizable", "start.appTitle", fallback: "Travel Memorize") }
    /// Curate your journey
    internal static var curateYourJorney: String { L10n.tr("Localizable", "start.curateYourJorney", fallback: "Curate your journey") }
    /// Save your favorite places, stories, and moments on a personal travel map.
    internal static var startSubtitle: String { L10n.tr("Localizable", "start.startSubtitle", fallback: "Save your favorite places, stories, and moments on a personal travel map.") }
    internal enum GetStarted {
      /// Start
      internal static var action: String { L10n.tr("Localizable", "start.getStarted.action", fallback: "Get started") }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = AppLocalization.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: AppLocalization.locale, arguments: args)
  }
}

@Observable
final class AppLanguageStore {
  var selectedLanguage: ProfileLanguage {
    didSet {
      AppLocalization.selectedLanguage = selectedLanguage
      refreshID = UUID()
    }
  }

  private(set) var refreshID = UUID()

  init() {
    selectedLanguage = AppLocalization.selectedLanguage
  }

  func selectLanguage(_ language: ProfileLanguage) {
    guard selectedLanguage != language else { return }
    selectedLanguage = language
  }
}

enum ProfileLanguage: String, CaseIterable, Identifiable {
  case english = "en"
  case russian = "ru"

  var id: String {
    rawValue
  }

  var title: String {
    switch self {
    case .english:
      L10n.Profile.Language.english
    case .russian:
      L10n.Profile.Language.russian
    }
  }

  var localeIdentifier: String {
    rawValue
  }

  static func storedValue(_ value: String?) -> ProfileLanguage {
    switch value {
    case ProfileLanguage.russian.rawValue, "Russian":
      return .russian
    case ProfileLanguage.english.rawValue, "English":
      return .english
    default:
      return .english
    }
  }
}

private enum AppLocalization {
  private static let storageKey = "app.selectedLanguage"

  static var selectedLanguage: ProfileLanguage {
    get {
      ProfileLanguage.storedValue(UserDefaults.standard.string(forKey: storageKey))
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: storageKey)
    }
  }

  static var bundle: Bundle {
    let baseBundle = BundleToken.bundle

    guard let path = baseBundle.path(
      forResource: selectedLanguage.localeIdentifier,
      ofType: "lproj"
    ),
      let localizedBundle = Bundle(path: path) else {
      return baseBundle
    }

    return localizedBundle
  }

  static var locale: Locale {
    Locale(identifier: selectedLanguage.localeIdentifier)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

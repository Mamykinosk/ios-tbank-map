// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

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
  internal static let settings = L10n.tr("Localizable", "Settings", fallback: "Settings")
  /// User
  internal static let userTitle = L10n.tr("Localizable", "userTitle", fallback: "User profile")
  internal enum Auth {
    internal enum Common {
      internal enum Email {
        /// Enter your email
        internal static let placeholder = L10n.tr("Localizable", "auth.common.email.placeholder", fallback: "Enter your email")
        /// Auth - Common
        internal static let title = L10n.tr("Localizable", "auth.common.email.title", fallback: "Email")
      }
      internal enum Password {
        /// Password
        internal static let title = L10n.tr("Localizable", "auth.common.password.title", fallback: "Password")
      }
    }
    internal enum Login {
      /// Forgot password?
      internal static let forgotPassword = L10n.tr("Localizable", "auth.login.forgotPassword", fallback: "Forgot password?")
      /// Don’t have an account?
      internal static let noAnyAccount = L10n.tr("Localizable", "auth.login.noAnyAccount", fallback: "Don’t have an account?")
      /// Or connect with
      internal static let orConnectWith = L10n.tr("Localizable", "auth.login.orConnectWith", fallback: "Or connect with")
      /// Register now
      internal static let registerNow = L10n.tr("Localizable", "auth.login.registerNow", fallback: "Register now")
      /// Sign in to continue your journey.
      internal static let subtitle = L10n.tr("Localizable", "auth.login.subtitle", fallback: "Sign in to continue your journey.")
      /// Auth - Login
      internal static let title = L10n.tr("Localizable", "auth.login.title", fallback: "Welcome back")
      internal enum Login {
        /// Log in
        internal static let action = L10n.tr("Localizable", "auth.login.login.action", fallback: "Log in")
      }
    }
    internal enum Recovery {
      /// Back to sign in
      internal static let backToSingIn = L10n.tr("Localizable", "auth.recovery.backToSingIn", fallback: "Back to sign in")
      /// Enter your email and we’ll send you a reset link.
      internal static let subtitle = L10n.tr("Localizable", "auth.recovery.subtitle", fallback: "Enter your email and we’ll send you a reset link.")
      /// Auth - Recovery
      internal static let title = L10n.tr("Localizable", "auth.recovery.title", fallback: "Reset password")
      internal enum SendResetLink {
        /// Send reset link
        internal static let action = L10n.tr("Localizable", "auth.recovery.sendResetLink.action", fallback: "Send reset link")
      }
    }
    internal enum Register {
      /// Register
      internal static let action = L10n.tr("Localizable", "auth.register.action", fallback: "Register")
      /// Already have an account?
      internal static let alreadyHaveAccount = L10n.tr("Localizable", "auth.register.alreadyHaveAccount", fallback: "Already have an account?")
      /// Log in now
      internal static let loginNow = L10n.tr("Localizable", "auth.register.loginNow", fallback: "Log in now")
      /// Join us and start collecting your memories.
      internal static let subtitle = L10n.tr("Localizable", "auth.register.subtitle", fallback: "Join us and start collecting your memories.")
      /// Auth - Register
      internal static let title = L10n.tr("Localizable", "auth.register.title", fallback: "Create account")
      internal enum ConfirmPassword {
        /// Confirm password
        internal static let title = L10n.tr("Localizable", "auth.register.confirmPassword.title", fallback: "Confirm password")
      }
      internal enum Username {
        /// Enter your username
        internal static let placeholder = L10n.tr("Localizable", "auth.register.username.placeholder", fallback: "Enter your username")
        /// Username
        internal static let title = L10n.tr("Localizable", "auth.register.username.title", fallback: "Username")
      }
    }
  }
  internal enum Common {
    /// Add
    internal static let add = L10n.tr("Localizable", "common.add", fallback: "Add")
    /// Common
    internal static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// Clear
    internal static let clear = L10n.tr("Localizable", "common.clear", fallback: "Clear")
    /// Delete
    internal static let delete = L10n.tr("Localizable", "common.delete", fallback: "Delete")
    /// Done
    internal static let done = L10n.tr("Localizable", "common.done", fallback: "Done")
    /// Edit
    internal static let edit = L10n.tr("Localizable", "common.edit", fallback: "Edit")
    /// Error
    internal static let error = L10n.tr("Localizable", "common.error", fallback: "Error")
    /// Loading...
    internal static let loading = L10n.tr("Localizable", "common.loading", fallback: "Loading...")
    /// Save
    internal static let save = L10n.tr("Localizable", "common.save", fallback: "Save")
    /// Search
    internal static let search = L10n.tr("Localizable", "common.search", fallback: "Search")
  }
  internal enum EditProfile {
    /// Back
    internal static let back = L10n.tr("Localizable", "editProfile.back", fallback: "Back")
    /// Change profile picture
    internal static let changeProfilePicture = L10n.tr("Localizable", "editProfile.changeProfilePicture", fallback: "Change profile picture")
    /// Personal Identity
    internal static let personalIdentity = L10n.tr("Localizable", "editProfile.personalIdentity", fallback: "Personal Identity")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "editProfile.settings", fallback: "Settings")
    /// Edit Profile
    internal static let title = L10n.tr("Localizable", "editProfile.title", fallback: "Edit Profile")
    internal enum AccountPrivacy {
      /// Manage your data visibility and account permanence.
      internal static let subtitle = L10n.tr("Localizable", "editProfile.accountPrivacy.subtitle", fallback: "Manage your data visibility and account permanence.")
      /// Account Privacy
      internal static let title = L10n.tr("Localizable", "editProfile.accountPrivacy.title", fallback: "Account Privacy")
    }
    internal enum Bio {
      /// Share your journey...
      internal static let placeholder = L10n.tr("Localizable", "editProfile.bio.placeholder", fallback: "Share your journey...")
      /// Bio
      internal static let title = L10n.tr("Localizable", "editProfile.bio.title", fallback: "Bio")
    }
    internal enum DeactivateAccount {
      /// Deactivate Account
      internal static let action = L10n.tr("Localizable", "editProfile.deactivateAccount.action", fallback: "Deactivate Account")
    }
    internal enum Email {
      /// Email Address
      internal static let title = L10n.tr("Localizable", "editProfile.email.title", fallback: "Email Address")
    }
    internal enum Error {
      /// This email is already in use.
      internal static let emailInUse = L10n.tr("Localizable", "editProfile.error.emailInUse", fallback: "This email is already in use.")
      /// Network error. Check your connection and try again.
      internal static let network = L10n.tr("Localizable", "editProfile.error.network", fallback: "Network error. Check your connection and try again.")
      /// For security, sign in again before changing your email.
      internal static let requiresRecentLogin = L10n.tr("Localizable", "editProfile.error.requiresRecentLogin", fallback: "For security, sign in again before changing your email.")
      /// Unable to update profile. Please try again.
      internal static let updateFailed = L10n.tr("Localizable", "editProfile.error.updateFailed", fallback: "Unable to update profile. Please try again.")
    }
    internal enum Location {
      /// Lisbon, Portugal
      internal static let placeholder = L10n.tr("Localizable", "editProfile.location.placeholder", fallback: "Lisbon, Portugal")
      /// Location
      internal static let title = L10n.tr("Localizable", "editProfile.location.title", fallback: "Location")
    }
    internal enum Message {
      /// Profile updated.
      internal static let profileUpdated = L10n.tr("Localizable", "editProfile.message.profileUpdated", fallback: "Profile updated.")
    }
    internal enum SaveChanges {
      /// Save Changes
      internal static let action = L10n.tr("Localizable", "editProfile.saveChanges.action", fallback: "Save Changes")
    }
    internal enum Username {
      /// Only English letters, numbers and underscores allowed.
      internal static let helper = L10n.tr("Localizable", "editProfile.username.helper", fallback: "Only English letters, numbers and underscores allowed.")
      /// Username
      internal static let title = L10n.tr("Localizable", "editProfile.username.title", fallback: "Username")
    }
  }
  internal enum Error {
    /// You don’t have permission to do this
    internal static let noPermission = L10n.tr("Localizable", "error.noPermission", fallback: "You don’t have permission to do this")
    /// Errors
    internal static let userNotAuthenticated = L10n.tr("Localizable", "error.userNotAuthenticated", fallback: "User is not authenticated")
  }
  internal enum Friends {
    /// Add friend
    internal static let addFriend = L10n.tr("Localizable", "friends.addFriend", fallback: "Add friend")
    /// All friends
    internal static let allFriends = L10n.tr("Localizable", "friends.allFriends", fallback: "All friends")
    /// Request already sent
    internal static let alreadyAdded = L10n.tr("Localizable", "friends.alreadyAdded", fallback: "Request already sent")
    /// Cities
    internal static let cities = L10n.tr("Localizable", "friends.cities", fallback: "Cities")
    /// Countries
    internal static let countries = L10n.tr("Localizable", "friends.countries", fallback: "Countries")
    /// No friends yet
    internal static let emptyFriends = L10n.tr("Localizable", "friends.emptyFriends", fallback: "No friends yet")
    /// Find people and add them to see their travel memories.
    internal static let emptyFriendsHint = L10n.tr("Localizable", "friends.emptyFriendsHint", fallback: "Find people and add them to see their travel memories.")
    /// No friends yet
    internal static let emptyFriendsTitle = L10n.tr("Localizable", "friends.emptyFriendsTitle", fallback: "No friends yet")
    /// This user has no memories on the map yet
    internal static let emptyUserMap = L10n.tr("Localizable", "friends.emptyUserMap", fallback: "This user has no memories on the map yet")
    /// Friend
    internal static let friend = L10n.tr("Localizable", "friends.friend", fallback: "Friend")
    /// Friend request
    internal static let friendRequest = L10n.tr("Localizable", "friends.friendRequest", fallback: "Friend request")
    /// Memories
    internal static let memories = L10n.tr("Localizable", "friends.memories", fallback: "Memories")
    /// No users found
    internal static let noUsersFound = L10n.tr("Localizable", "friends.noUsersFound", fallback: "No users found")
    /// Remove this friend?
    internal static let removeConfirmation = L10n.tr("Localizable", "friends.removeConfirmation", fallback: "Remove this friend?")
    /// Remove friend
    internal static let removeFriend = L10n.tr("Localizable", "friends.removeFriend", fallback: "Remove friend")
    /// Requests
    internal static let requests = L10n.tr("Localizable", "friends.requests", fallback: "Requests")
    /// Sent
    internal static let sent = L10n.tr("Localizable", "friends.sent", fallback: "Sent")
    /// Show map
    internal static let showMap = L10n.tr("Localizable", "friends.showMap", fallback: "Show map")
    /// Social
    internal static let social = L10n.tr("Localizable", "friends.social", fallback: "Social")
    /// Friends
    internal static let title = L10n.tr("Localizable", "friends.title", fallback: "Friends")
    /// Unknown user
    internal static let unknownUser = L10n.tr("Localizable", "friends.unknownUser", fallback: "Unknown user")
    /// User map
    internal static let userMap = L10n.tr("Localizable", "friends.userMap", fallback: "User map")
    /// Your friends
    internal static let yourFriends = L10n.tr("Localizable", "friends.yourFriends", fallback: "Your friends")
    internal enum Error {
      /// You are already friends
      internal static let alreadyFriends = L10n.tr("Localizable", "friends.error.alreadyFriends", fallback: "You are already friends")
      /// You can’t add yourself as a friend
      internal static let cannotAddYourself = L10n.tr("Localizable", "friends.error.cannotAddYourself", fallback: "You can’t add yourself as a friend")
      /// Friend request already sent
      internal static let requestAlreadySent = L10n.tr("Localizable", "friends.error.requestAlreadySent", fallback: "Friend request already sent")
      /// Something went wrong with friends service
      internal static let unknown = L10n.tr("Localizable", "friends.error.unknown", fallback: "Something went wrong with friends service")
    }
    internal enum Message {
      /// Friend request accepted
      internal static let accepted = L10n.tr("Localizable", "friends.message.accepted", fallback: "Friend request accepted")
      /// Friend request rejected
      internal static let rejected = L10n.tr("Localizable", "friends.message.rejected", fallback: "Friend request rejected")
      /// Friend removed
      internal static let removed = L10n.tr("Localizable", "friends.message.removed", fallback: "Friend removed")
      /// Messages
      internal static let requestSent = L10n.tr("Localizable", "friends.message.requestSent", fallback: "Friend request sent")
    }
    internal enum Profile {
      /// Friend profile
      internal static let title = L10n.tr("Localizable", "friends.profile.title", fallback: "Friend profile")
    }
    internal enum Search {
      /// Search friends
      internal static let placeholder = L10n.tr("Localizable", "friends.search.placeholder", fallback: "Search friends")
    }
  }
  internal enum Logged {
    internal enum TabBar {
      /// Feed
      internal static let feed = L10n.tr("Localizable", "logged.tabBar.feed", fallback: "Feed")
      /// Friends
      internal static let friends = L10n.tr("Localizable", "logged.tabBar.friends", fallback: "Friends")
      /// Tab bar
      internal static let map = L10n.tr("Localizable", "logged.tabBar.map", fallback: "Map")
      /// Profile
      internal static let profile = L10n.tr("Localizable", "logged.tabBar.profile", fallback: "Profile")
    }
  }
  internal enum Main {
    /// Email
    internal static let email = L10n.tr("Localizable", "main.email", fallback: "Email")
    /// Not found
    internal static let notFound = L10n.tr("Localizable", "main.notFound", fallback: "Not found")
    /// Not specified
    internal static let notSpecified = L10n.tr("Localizable", "main.notSpecified", fallback: "Not specified")
    /// Sign out
    internal static let signOut = L10n.tr("Localizable", "main.signOut", fallback: "Sign out")
    /// UID
    internal static let uid = L10n.tr("Localizable", "main.uid", fallback: "UID")
    internal enum SignedIn {
      /// Main
      internal static let title = L10n.tr("Localizable", "main.signedIn.title", fallback: "Signed in")
    }
  }
  internal enum Memories {
    /// Add
    internal static let add = L10n.tr("Localizable", "memories.add", fallback: "Add")
    /// Add photos
    internal static let addPhotos = L10n.tr("Localizable", "memories.addPhotos", fallback: "Add photos")
    /// Memories
    internal static let appTitle = L10n.tr("Localizable", "memories.appTitle", fallback: "Memories")
    /// Discard this memory?
    internal static let cancelAddConfirmation = L10n.tr("Localizable", "memories.cancelAddConfirmation", fallback: "Discard this memory?")
    /// Discard changes?
    internal static let cancelEditConfirmation = L10n.tr("Localizable", "memories.cancelEditConfirmation", fallback: "Discard changes?")
    /// Capture
    internal static let capture = L10n.tr("Localizable", "memories.capture", fallback: "Capture")
    /// Choose location
    internal static let chooseLocation = L10n.tr("Localizable", "memories.chooseLocation", fallback: "Choose location")
    /// No story yet
    internal static let defaultPreviewSubtitle = L10n.tr("Localizable", "memories.defaultPreviewSubtitle", fallback: "No story yet")
    /// Untitled memory
    internal static let defaultPreviewTitle = L10n.tr("Localizable", "memories.defaultPreviewTitle", fallback: "Untitled memory")
    /// This memory will be permanently deleted.
    internal static let deleteConfirmation = L10n.tr("Localizable", "memories.deleteConfirmation", fallback: "This memory will be permanently deleted.")
    /// Delete marker
    internal static let deleteMarker = L10n.tr("Localizable", "memories.deleteMarker", fallback: "Delete marker")
    /// Delete permanently
    internal static let deletePermanently = L10n.tr("Localizable", "memories.deletePermanently", fallback: "Delete permanently")
    /// Edit marker
    internal static let editMarkerTitle = L10n.tr("Localizable", "memories.editMarkerTitle", fallback: "Edit marker")
    /// Edit memory
    internal static let editTitle = L10n.tr("Localizable", "memories.editTitle", fallback: "Edit memory")
    /// No memories yet
    internal static let emptyFeed = L10n.tr("Localizable", "memories.emptyFeed", fallback: "No memories yet")
    /// History story
    internal static let historyStory = L10n.tr("Localizable", "memories.historyStory", fallback: "History story")
    /// items
    internal static let items = L10n.tr("Localizable", "memories.items", fallback: "items")
    /// Last summer
    internal static let lastSummer = L10n.tr("Localizable", "memories.lastSummer", fallback: "Last summer")
    /// Long press on the map to choose a location
    internal static let longPressHint = L10n.tr("Localizable", "memories.longPressHint", fallback: "Long press on the map to choose a location")
    /// Memory
    internal static let memoryTitle = L10n.tr("Localizable", "memories.memoryTitle", fallback: "Memory")
    /// New memory
    internal static let newMemoryTitle = L10n.tr("Localizable", "memories.newMemoryTitle", fallback: "New memory")
    /// No memories found
    internal static let noMemoriesFound = L10n.tr("Localizable", "memories.noMemoriesFound", fallback: "No memories found")
    /// No story added
    internal static let noStoryAdded = L10n.tr("Localizable", "memories.noStoryAdded", fallback: "No story added")
    /// Photo gallery
    internal static let photoGallery = L10n.tr("Localizable", "memories.photoGallery", fallback: "Photo gallery")
    /// photos
    internal static let photos = L10n.tr("Localizable", "memories.photos", fallback: "photos")
    /// Place name
    internal static let placeName = L10n.tr("Localizable", "memories.placeName", fallback: "Place name")
    /// Enter place name
    internal static let placeNamePlaceholder = L10n.tr("Localizable", "memories.placeNamePlaceholder", fallback: "Enter place name")
    /// Place name is required
    internal static let placeNameRequired = L10n.tr("Localizable", "memories.placeNameRequired", fallback: "Place name is required")
    /// Recent archive
    internal static let recentArchive = L10n.tr("Localizable", "memories.recentArchive", fallback: "Recent archive")
    /// Save changes
    internal static let saveChanges = L10n.tr("Localizable", "memories.saveChanges", fallback: "Save changes")
    /// Save memory
    internal static let saveMemory = L10n.tr("Localizable", "memories.saveMemory", fallback: "Save memory")
    /// Try searching by place, city, country, or story.
    internal static let searchNoResultsHint = L10n.tr("Localizable", "memories.searchNoResultsHint", fallback: "Try searching by place, city, country, or story.")
    /// Stay
    internal static let stay = L10n.tr("Localizable", "memories.stay", fallback: "Stay")
    /// Tell the story behind this memory
    internal static let storyPlaceholder = L10n.tr("Localizable", "memories.storyPlaceholder", fallback: "Tell the story behind this memory")
    /// The story
    internal static let theStory = L10n.tr("Localizable", "memories.theStory", fallback: "The story")
    /// Visit date
    internal static let visitDate = L10n.tr("Localizable", "memories.visitDate", fallback: "Visit date")
    /// Visit date is required
    internal static let visitDateRequired = L10n.tr("Localizable", "memories.visitDateRequired", fallback: "Visit date is required")
    internal enum Error {
      /// Memory location is missing
      internal static let coordinateMissing = L10n.tr("Localizable", "memories.error.coordinateMissing", fallback: "Memory location is missing")
      /// Something went wrong with memories service
      internal static let unknown = L10n.tr("Localizable", "memories.error.unknown", fallback: "Something went wrong with memories service")
    }
    internal enum Feed {
      /// Memories feed
      internal static let title = L10n.tr("Localizable", "memories.feed.title", fallback: "Memories feed")
    }
    internal enum Message {
      /// Memory deleted
      internal static let deleted = L10n.tr("Localizable", "memories.message.deleted", fallback: "Memory deleted")
      /// Memory saved
      internal static let saved = L10n.tr("Localizable", "memories.message.saved", fallback: "Memory saved")
      /// Memory updated
      internal static let updated = L10n.tr("Localizable", "memories.message.updated", fallback: "Memory updated")
    }
    internal enum Search {
      /// Search memories
      internal static let placeholder = L10n.tr("Localizable", "memories.search.placeholder", fallback: "Search memories")
    }
    internal enum SearchMemories {
      /// Search memories
      internal static let title = L10n.tr("Localizable", "memories.searchMemories.title", fallback: "Search memories")
    }
  }
  internal enum Profile {
    /// Profile
    internal static let defaultDisplayName = L10n.tr("Localizable", "profile.defaultDisplayName", fallback: "Traveler")
    /// @traveler
    internal static let defaultUsername = L10n.tr("Localizable", "profile.defaultUsername", fallback: "@traveler")
    internal enum EditProfile {
      /// Edit Profile
      internal static let action = L10n.tr("Localizable", "profile.editProfile.action", fallback: "Edit Profile")
    }
    internal enum Language {
      /// English
      internal static let english = L10n.tr("Localizable", "profile.language.english", fallback: "English")
      /// Russian
      internal static let russian = L10n.tr("Localizable", "profile.language.russian", fallback: "Russian")
    }
    internal enum Logout {
      /// Logout
      internal static let action = L10n.tr("Localizable", "profile.logout.action", fallback: "Logout")
      /// Unable to logout. Please try again.
      internal static let error = L10n.tr("Localizable", "profile.logout.error", fallback: "Unable to logout. Please try again.")
    }
    internal enum Preferences {
      /// Dark Mode
      internal static let darkMode = L10n.tr("Localizable", "profile.preferences.darkMode", fallback: "Dark Mode")
      /// Language
      internal static let language = L10n.tr("Localizable", "profile.preferences.language", fallback: "Language")
      /// Preferences
      internal static let title = L10n.tr("Localizable", "profile.preferences.title", fallback: "Preferences")
    }
    internal enum Stats {
      /// Cities
      internal static let cities = L10n.tr("Localizable", "profile.stats.cities", fallback: "Cities")
      /// Countries
      internal static let countries = L10n.tr("Localizable", "profile.stats.countries", fallback: "Countries")
      /// Memories
      internal static let memories = L10n.tr("Localizable", "profile.stats.memories", fallback: "Memories")
    }
  }
  internal enum Start {
    /// Curate your journey
    internal static let curateYourJorney = L10n.tr("Localizable", "start.curateYourJorney", fallback: "Curate your journey")
    /// Save your favorite places, stories, and moments on a personal travel map.
    internal static let startSubtitle = L10n.tr("Localizable", "start.startSubtitle", fallback: "Save your favorite places, stories, and moments on a personal travel map.")
    internal enum GetStarted {
      /// Start
      internal static let action = L10n.tr("Localizable", "start.getStarted.action", fallback: "Get started")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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

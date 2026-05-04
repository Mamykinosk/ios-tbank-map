import SwiftUI

enum L10n {
    enum Common {
        static let cancel: LocalizedStringKey = "common.cancel"
        static let save: LocalizedStringKey = "common.save"
        static let delete: LocalizedStringKey = "common.delete"
        static let edit: LocalizedStringKey = "common.edit"
        static let add: LocalizedStringKey = "common.add"
        static let loading: LocalizedStringKey = "common.loading"
        static let error: LocalizedStringKey = "common.error"
        static let clear: LocalizedStringKey = "common.clear"
        static let done: LocalizedStringKey = "common.done"
        static let search: LocalizedStringKey = "common.search"
    }
    
    enum Start {
        static let getStartedAction: LocalizedStringKey = "start.getStarted.action"
        static let curateYourJorney: LocalizedStringKey = "start.curateYourJorney"
        static let startSubtitle: LocalizedStringKey = "start.startSubtitle"
    }

    enum Auth {
        enum Register {
            static let registerTitle: LocalizedStringKey = "auth.register.title"
            static let registerSubtitle: LocalizedStringKey = "auth.register.subtitle"
            static let usernameTitle: LocalizedStringKey = "auth.register.username.title"
            static let confirmPasswordTitle: LocalizedStringKey = "auth.register.confirmPassword.title"
            static let usernamePlaceholder: LocalizedStringKey = "auth.register.username.placeholder"
            static let alreadyHaveAccount: LocalizedStringKey = "auth.register.alreadyHaveAccount"
            static let loginNow: LocalizedStringKey = "auth.register.loginNow"
            static let registerAction: LocalizedStringKey = "auth.register.action"
        }

        enum Login {
            static let loginTitle: LocalizedStringKey = "auth.login.title"
            static let loginSubtitle: LocalizedStringKey = "auth.login.subtitle"
            static let loginAction: LocalizedStringKey = "auth.login.login.action"
            static let forgotPassword: LocalizedStringKey = "auth.login.forgotPassword"
            static let orConnectWith: LocalizedStringKey = "auth.login.orConnectWith"
            static let noAnyAccount: LocalizedStringKey = "auth.login.noAnyAccount"
            static let registerNow: LocalizedStringKey = "auth.login.registerNow"
        }

        enum Recovery {
            static let resetPasswordTitle: LocalizedStringKey = "auth.recovery.title"
            static let resetPasswordSubtitle: LocalizedStringKey = "auth.recovery.subtitle"
            static let sendResetLinkAction: LocalizedStringKey = "auth.recovery.sendResetLink.action"
            static let backToSingIn: LocalizedStringKey = "auth.recovery.backToSingIn"
        }

        enum Common {
            static let emailTitle: LocalizedStringKey = "auth.common.email.title"
            static let passwordTitle: LocalizedStringKey = "auth.common.password.title"
            static let emailPlaceholder: LocalizedStringKey = "auth.common.email.placeholder"
        }
    }
    enum Main {
        static let signedInTitle: LocalizedStringKey = "main.signedIn.title"
        static let email: LocalizedStringKey = "main.email"
        static let uid: LocalizedStringKey = "main.uid"
        static let notSpecified: LocalizedStringKey = "main.notSpecified"
        static let notFound: LocalizedStringKey = "main.notFound"
        static let signOut: LocalizedStringKey = "main.signOut"
    }
    
    enum Message {
        static var friendRequestSent: String { String(localized: "friends.message.requestSent") }
        static var friendRemoved: String { String(localized: "friends.message.removed") }
        static var friendRequestAccepted: String { String(localized: "friends.message.accepted") }
        static var friendRequestRejected: String { String(localized: "friends.message.rejected") }
        static var memorySaved: String { String(localized: "memories.message.saved") }
        static var memoryUpdated: String { String(localized: "memories.message.updated") }
        static var memoryDeleted: String { String(localized: "memories.message.deleted") }

        static var userNotAuthenticated: String { String(localized: "error.userNotAuthenticated") }
        static var cannotAddYourself: String { String(localized: "friends.error.cannotAddYourself") }
        static var alreadyFriends: String { String(localized: "friends.error.alreadyFriends") }
        static var friendRequestAlreadySent: String { String(localized: "friends.error.requestAlreadySent") }
        static var noPermission: String { String(localized: "error.noPermission") }
        static var unknownFriendsServiceError: String { String(localized: "friends.error.unknown") }
        static var memoryCoordinateMissing: String { String(localized: "memories.error.coordinateMissing") }
        static var unknownMemoryServiceError: String { String(localized: "memories.error.unknown") }
    }
    
    enum TabBar {
        static let map: LocalizedStringKey = "logged.tabBar.map"
        static let feed: LocalizedStringKey = "logged.tabBar.feed"
        static let friends: LocalizedStringKey = "logged.tabBar.friends"
        static let profile: LocalizedStringKey = "logged.tabBar.profile"
    }

    enum Memories {
        static let appTitle: LocalizedStringKey = "memories.appTitle"
        
        static let newMemoryTitle: LocalizedStringKey = "memories.newMemoryTitle"
        static let editMarkerTitle: LocalizedStringKey = "memories.editMarkerTitle"
        static let editTitle: LocalizedStringKey = "memories.editTitle"
        
        static let capture: LocalizedStringKey = "memories.capture"
        static let addPhotos: LocalizedStringKey = "memories.addPhotos"
        static let photoGallery: LocalizedStringKey = "memories.photoGallery"
        static let add: LocalizedStringKey = "memories.add"
        
        static let placeName: LocalizedStringKey = "memories.placeName"
        static let placeNameRequired: LocalizedStringKey = "memories.placeNameRequired"
        static let placeNamePlaceholder: LocalizedStringKey = "memories.placeNamePlaceholder"
        
        static let visitDate: LocalizedStringKey = "memories.visitDate"
        static let visitDateRequired: LocalizedStringKey = "memories.visitDateRequired"
        
        static let historyStory: LocalizedStringKey = "memories.historyStory"
        static let theStory: LocalizedStringKey = "memories.theStory"
        static let storyPlaceholder: LocalizedStringKey = "memories.storyPlaceholder"
        
        
        
        static let saveMemory: LocalizedStringKey = "memories.saveMemory"
        static let saveChanges: LocalizedStringKey = "memories.saveChanges"
        static let deleteMarker: LocalizedStringKey = "memories.deleteMarker"
        static let deletePermanently: LocalizedStringKey = "memories.deletePermanently"
        
        static let chooseLocation: LocalizedStringKey = "memories.chooseLocation"
        static let longPressHint: LocalizedStringKey = "memories.longPressHint"
        
        static let lastSummer: LocalizedStringKey = "memories.lastSummer"
        static let defaultPreviewTitle: LocalizedStringKey = "memories.defaultPreviewTitle"
        static let defaultPreviewSubtitle: LocalizedStringKey = "memories.defaultPreviewSubtitle"
        
        static let cancelEditConfirmation: LocalizedStringKey = "memories.cancelEditConfirmation"
        static let cancelAddConfirmation: LocalizedStringKey = "memories.cancelAddConfirmation"
        static let deleteConfirmation: LocalizedStringKey = "memories.deleteConfirmation"
        static let stay: LocalizedStringKey = "memories.stay"
        static let photos: LocalizedStringKey = "memories.photos"
        static let items: LocalizedStringKey = "memories.items"
        static let searchMemoriesTitle: LocalizedStringKey = "memories.searchMemories.title"
        static let noMemoriesFound: LocalizedStringKey = "memories.noMemoriesFound"
        static let searchNoResultsHint: LocalizedStringKey = "memories.searchNoResultsHint"
        static let noStoryAdded: LocalizedStringKey = "memories.noStoryAdded"
        static let memoryTitle: LocalizedStringKey = "memories.memoryTitle"
    }
    
    //<<<<<<< HEAD
    enum Profile {
        static let preferencesTitle: LocalizedStringKey = "profile.preferences.title"
        static let darkMode: LocalizedStringKey = "profile.preferences.darkMode"
        static let language: LocalizedStringKey = "profile.preferences.language"
        static let editProfileAction: LocalizedStringKey = "profile.editProfile.action"
        static let logoutAction: LocalizedStringKey = "profile.logout.action"
        static let logoutError: String.LocalizationValue = "profile.logout.error"
        
        enum Stats {
            static let countries: LocalizedStringKey = "profile.stats.countries"
            static let cities: LocalizedStringKey = "profile.stats.cities"
            static let memories: LocalizedStringKey = "profile.stats.memories"
        }
        
        enum Language {
            static let english: LocalizedStringKey = "profile.language.english"
            static let russian: LocalizedStringKey = "profile.language.russian"
        }
        
        static let defaultDisplayName: String.LocalizationValue = "profile.defaultDisplayName"
        static let defaultUsername: String.LocalizationValue = "profile.defaultUsername"
    }
    
    enum EditProfile {
        static let title: LocalizedStringKey = "editProfile.title"
        static let back: LocalizedStringKey = "editProfile.back"
        static let settings: LocalizedStringKey = "editProfile.settings"
        static let changeProfilePicture: LocalizedStringKey = "editProfile.changeProfilePicture"
        static let personalIdentity: LocalizedStringKey = "editProfile.personalIdentity"
        static let usernameTitle: LocalizedStringKey = "editProfile.username.title"
        static let usernameHelper: LocalizedStringKey = "editProfile.username.helper"
        static let emailTitle: LocalizedStringKey = "editProfile.email.title"
        static let locationTitle: LocalizedStringKey = "editProfile.location.title"
        static let locationPlaceholder: LocalizedStringKey = "editProfile.location.placeholder"
        static let bioTitle: LocalizedStringKey = "editProfile.bio.title"
        static let bioPlaceholder: LocalizedStringKey = "editProfile.bio.placeholder"
        static let saveChangesAction: LocalizedStringKey = "editProfile.saveChanges.action"
        static let accountPrivacyTitle: LocalizedStringKey = "editProfile.accountPrivacy.title"
        static let accountPrivacySubtitle: LocalizedStringKey = "editProfile.accountPrivacy.subtitle"
        static let deactivateAccount: LocalizedStringKey = "editProfile.deactivateAccount.action"
        
        enum Message {
            static let profileUpdated: String.LocalizationValue = "editProfile.message.profileUpdated"
            static let updateFailed: String.LocalizationValue = "editProfile.error.updateFailed"
            static let emailInUse: String.LocalizationValue = "editProfile.error.emailInUse"
            static let requiresRecentLogin: String.LocalizationValue = "editProfile.error.requiresRecentLogin"
            static let networkError: String.LocalizationValue = "editProfile.error.network"
        }
        //=======
        
    }

    enum Friends {
        static let title: LocalizedStringKey = "friends.title"
        static let profileTitle: LocalizedStringKey = "friends.profile.title"
        static let searchPlaceholder: LocalizedStringKey = "friends.search.placeholder"
        static let emptyFriends: LocalizedStringKey = "friends.emptyFriends"
        static let noUsersFound: LocalizedStringKey = "friends.noUsersFound"
        static let addFriend: LocalizedStringKey = "friends.addFriend"
        static let removeFriend: LocalizedStringKey = "friends.removeFriend"
        static let removeConfirmation: LocalizedStringKey = "friends.removeConfirmation"
        static let showMap: LocalizedStringKey = "friends.showMap"
        static let userMap: LocalizedStringKey = "friends.userMap"
        static let emptyUserMap: LocalizedStringKey = "friends.emptyUserMap"
        static let memories: LocalizedStringKey = "friends.memories"
        static let countries: LocalizedStringKey = "friends.countries"
        static let cities: LocalizedStringKey = "friends.cities"
        static let social: LocalizedStringKey = "friends.social"
        static let yourFriends: LocalizedStringKey = "friends.yourFriends"
        static let requests: LocalizedStringKey = "friends.requests"
        static let unknownUser: LocalizedStringKey = "friends.unknownUser"
        static let friendRequest: LocalizedStringKey = "friends.friendRequest"
        static let allFriends: LocalizedStringKey = "friends.allFriends"
        static let emptyFriendsTitle: LocalizedStringKey = "friends.emptyFriendsTitle"
        static let emptyFriendsHint: LocalizedStringKey = "friends.emptyFriendsHint"
        static let friend: LocalizedStringKey = "friends.friend"
        static let sent: LocalizedStringKey = "friends.sent"
    }
    
    static let profileTitle: LocalizedStringKey = "userTitle"
        //>>>>>>> 0bfca34 (Added memories functionality to app)
    }


import SwiftUI

enum L10n {
    
    enum Start {
        static let getStartedAction:  LocalizedStringKey = "start.getStarted.action"
        static let curateYourJorney:  LocalizedStringKey = "start.curateYourJorney"
        static let startSubtitle:  LocalizedStringKey = "start.startSubtitle"
    }
    
    enum Auth {
        enum Register {
            static let registerTitle: LocalizedStringKey = "auth.register.title"
            static let registerSubtitle: LocalizedStringKey = "auth.register.subtitle"
            static let usernameTitle: LocalizedStringKey = "auth.register.username.title"
            static let confirmPasswordTitle: LocalizedStringKey = "auth.register.confirmPassword.title"
            static let usernamePlaceholder: LocalizedStringKey = "auth.register.username.placeholder"//
            static let alreadyHaveAccount: LocalizedStringKey = "auth.register.alreadyHaveAccount"//
            static let loginNow: LocalizedStringKey = "auth.register.loginNow"//
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
            static let emailTitle: LocalizedStringKey = "auth.common.email.title" //
            static let passwordTitle: LocalizedStringKey = "auth.common.password.title" //
            static let emailPlaceholder: LocalizedStringKey = "auth.common.email.placeholder"
        }
    }

    enum TabBar {
        static let map: LocalizedStringKey = "logged.tabBar.map"
        static let feed: LocalizedStringKey = "logged.tabBar.feed"
        static let friends: LocalizedStringKey = "logged.tabBar.friends"
        static let profile: LocalizedStringKey = "logged.tabBar.profile"
    }

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
    }
}

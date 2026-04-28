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
}

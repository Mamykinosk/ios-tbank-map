import SwiftUI

enum AppTab: CaseIterable, Hashable {
    case map
    case feed
    case friends
    case profile

    var title: String {
        switch self {
        case .map:
            return L10n.Logged.TabBar.map
        case .feed:
            return L10n.Logged.TabBar.feed
        case .friends:
            return L10n.Logged.TabBar.friends
        case .profile:
            return L10n.Logged.TabBar.profile
        }
    }

    var systemImage: String {
        switch self {
        case .map:
            return "map"
        case .feed:
            return "book"
        case .friends:
            return "person.2"
        case .profile:
            return "person"
        }
    }
}

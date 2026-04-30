enum MainRoute: Hashable {
    case profile
    case editProfile
    case settings
}

enum MainTab: CaseIterable, Hashable {
    case map
    case feed
    case friends
    case profile
}

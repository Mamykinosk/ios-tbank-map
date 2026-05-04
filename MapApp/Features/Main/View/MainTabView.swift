import SwiftUI

struct MainTabView: View {
    @Environment(AuthSessionStore.self) private var authSession

    @State private var selectedTab: AppTab = .map
    @State private var memoriesViewModel = MemoriesViewModel()
    @State private var friendsViewModel = FriendsViewModel()

    var body: some View {
        @Bindable var memoriesViewModel = memoriesViewModel

        ZStack {
            switch selectedTab {
            case .map:
                MainMapView(selectedTab: $selectedTab, viewModel: memoriesViewModel)
            case .feed:
                MemoriesFeedView(selectedTab: $selectedTab, viewModel: memoriesViewModel)
            case .friends:
                FriendsView(selectedTab: $selectedTab, viewModel: friendsViewModel)
            case .profile:
                MainView(selectedTab: $selectedTab)
            }
        }
        .task(id: authSession.currentUser?.uid) {
            if let userId = authSession.currentUser?.uid {
                memoriesViewModel.startListening(ownerId: userId)
            } else {
                memoriesViewModel.stopListening()
            }
        }
        .onDisappear {
            memoriesViewModel.stopListening()
        }
    }
}

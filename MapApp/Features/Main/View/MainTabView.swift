import SwiftUI

struct MainTabView: View {
    @Environment(AppCoordinator.self) private var router
    @Environment(AuthSessionStore.self) private var authSession

    @State private var memoriesViewModel = MemoriesViewModel()
    @State private var friendsViewModel = FriendsViewModel()

    var body: some View {
        @Bindable var memoriesViewModel = memoriesViewModel
        @Bindable var router = router

        NavigationStack(path: $router.mainPath) {
            ZStack {
                switch router.selectedMainTab {
                case .map:
                    MainMapView(selectedTab: $router.selectedMainTab, viewModel: memoriesViewModel)
                case .feed:
                    MemoriesFeedView(selectedTab: $router.selectedMainTab, viewModel: memoriesViewModel)
                case .friends:
                    FriendsView(selectedTab: $router.selectedMainTab, viewModel: friendsViewModel)
                case .profile:
                    ProfileView()
                }
            }
            .navigationDestination(for: MainRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                case .editProfile:
                    EditProfileView()
                case .settings:
                    EmptyView()
                }
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

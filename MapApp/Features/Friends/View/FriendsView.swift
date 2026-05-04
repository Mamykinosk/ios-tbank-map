import SwiftUI

struct FriendsView: View {
    @Environment(AuthSessionStore.self) private var authSession

    @Binding var selectedTab: AppTab

    @State private var isSearchPresented = false
    @State private var selectedSearchFriend: FriendUser?
    @State private var selectedSearchUser: FriendUser?

    @Bindable var viewModel: FriendsViewModel

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection

                    searchField

                    messagesSection

                    if !viewModel.incomingRequests.isEmpty {
                        incomingRequestsSection
                    }

                    friendsSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 96)
                .padding(.bottom, 160)
            }

            topBar

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    AppFloatingAddButton {
                        isSearchPresented = true
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 128)
                }
            }

            VStack {
                Spacer()

                AppBottomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .sheet(isPresented: $isSearchPresented) {
            searchSheet
        }
        .sheet(item: $viewModel.selectedFriendForProfile) { friend in
            FriendProfileView(friend: friend)
        }
        .task(id: authSession.currentUser?.uid) {
            if let userId = authSession.currentUser?.uid {
                viewModel.start(currentUserId: userId)
            } else {
                viewModel.reset()
            }
        }
    }

    private var topBar: some View {
        VStack(spacing: 0) {
            HStack {
                Text(L10n.Friends.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.appPrimary)

                Spacer()

                Button {
                    isSearchPresented = true
                } label: {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.appPrimary)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)

                Button {
                    // settings later
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.appPrimary)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .frame(height: 64)
            .background(Color.white.opacity(0.75))

            Spacer()
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.Friends.social)
                .font(.system(size: 11, weight: .bold))
                .tracking(2.2)
                .foregroundStyle(Color.appPrimary)

            Text(L10n.Friends.yourFriends)
                .font(.system(size: 30, weight: .heavy))
                .tracking(-1.5)
                .foregroundStyle(Color.appTitle)
        }
    }

    private var searchField: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.appPlaceholder)

            TextField(L10n.Friends.searchPlaceholder, text: $viewModel.searchFriendText)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appTitle)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit {
                    viewModel.searchUsers()
                }

            Spacer()

            if !viewModel.searchUserText.isEmpty {
                Button {
                    viewModel.clearUserSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.appPlaceholder)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 60)
        .background(Color.appFieldBackground.opacity(0.75))
        .clipShape(Capsule())
    }

    private var messagesSection: some View {
        VStack(spacing: 8) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appError)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appPrimary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var incomingRequestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.Friends.requests)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.appTitle)

            ForEach(viewModel.incomingRequests) { request in
                RequestRow(
                    request: request,
                    acceptRequest: {
                        viewModel.acceptRequest(request)
                        if request.sender != nil {
                            viewModel.friends.append(request.sender!)
                        }
                        viewModel.incomingRequests.removeAll(where: { $0.id == request.id } )
                    },
                    rejectRequest: {
                        viewModel.rejectRequest(request)
                        viewModel.incomingRequests.removeAll(where: { $0.id == request.id } )
                    }
                )
            }
        }
    }

    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.searchFriendText.isEmpty {
                HStack {
                    Text(L10n.Friends.allFriends)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.appTitle)
                    
                    Spacer()
                    
                    Text("\(viewModel.friends.count)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.appPlaceholder)
                }
                
                if viewModel.friends.isEmpty {
                    emptyFriendsView
                }
                else {
                    ForEach(viewModel.friends, id: \.id) { friend in
                        FriendRow(friend: friend,
                                  openProfile: {
                            viewModel.openProfile(for: friend)
                        }
                        )
                    }
                }
            }
            else {
                let filteredFriends = viewModel.searchFriends()

                if filteredFriends.isEmpty && !viewModel.isSearching {
                    Text(L10n.Friends.noUsersFound)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.appPlaceholder)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 24)
                } else {
                    VStack(spacing: 12) {
                        ForEach(filteredFriends, id: \.id) { friend in
                            SearchResultRow(
                                user: friend,
                                viewModel: viewModel,
                                isSearchPresented: false,
                                onSelect: {
                                    viewModel.openProfile(for: friend)
                                }
                            )
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private var emptyFriendsView: some View {
        VStack(spacing: 14) {
            Image(systemName: "person.2")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(Color.appPrimary.opacity(0.7))

            Text(L10n.Friends.emptyFriendsTitle)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appSecondary)
                .multilineTextAlignment(.center)

            Text(L10n.Friends.emptyFriendsHint)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color.appPlaceholder)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var searchSheet: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.appPlaceholder)

                        TextField(L10n.Friends.searchPlaceholder, text: $viewModel.searchUserText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.appTitle)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.search)
                            .onSubmit {
                                viewModel.searchUsers()
                            }

                        Button {
                            viewModel.searchUsers()
                        } label: {
                            if viewModel.isSearching {
                                ProgressView()
                                    .tint(Color.appPrimary)
                            } else {
                                Text(L10n.Common.search)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color.appPrimary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 54)
                    .background(Color.white)
                    .clipShape(Capsule())

                    if viewModel.searchUserResults.isEmpty && !viewModel.searchUserText.isEmpty && !viewModel.isSearching {
                        Text(L10n.Friends.noUsersFound)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color.appPlaceholder)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 24)
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.searchUserResults, id: \.id ) { user in
                                    SearchResultRow(
                                        user: user,
                                        viewModel: viewModel,
                                        isSearchPresented: true,
                                        onSelect:
                                        {
                                        if viewModel.isAlreadyFriend(user) {
                                            selectedSearchFriend = user
                                        }
                                        else {
                                            selectedSearchUser = user
                                        }
                                        }
                                    )
                                }
                            }
                            .padding(.bottom, 24)
                        }
                    }

                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle(L10n.Friends.addFriend)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedSearchFriend) { friend in
                FriendProfileView(friend: friend, showsCustomBackButton: true)
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(item: $selectedSearchUser) { user in
                UserProfileView(user: user,
                                showsCustomBackButton: true, sendDisabled:  viewModel.outgoingRequestIds.contains(user.id))
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .navigationBar)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.Common.clear) {
                        viewModel.clearUserSearch()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        isSearchPresented = false
                    }
                }
            }
        }
    }
}

private extension Color {
    static let friendRejectBackground = Color(red: 186 / 255, green: 26 / 255, blue: 26 / 255).opacity(0.08)
    static let friendAvatarBackground = Color(red: 209 / 255, green: 250 / 255, blue: 229 / 255).opacity(0.5)
}

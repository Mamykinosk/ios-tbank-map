import SwiftUI
import MapboxMaps

struct RequestProfileView: View {
    @Environment(\.dismiss) private var dismiss

    private enum RequestProfileState: Equatable {
        case pending
        case friend
        case notFriend
    }

    let request: FriendRequest
    let showsCustomBackButton: Bool

    @State private var viewModel: FriendProfileViewModel
    @State private var selectedMemoryForDetails: Memory?
    @State private var profileState: RequestProfileState = .pending

    init(request: FriendRequest, showsCustomBackButton: Bool = true) {
        self.request = request
        self.showsCustomBackButton = showsCustomBackButton

        let sender = request.sender ?? FriendUser(
            id: request.senderId,
            username: L10n.Friends.unknownUser,
            email: ""
        )

        _viewModel = State(initialValue: FriendProfileViewModel(friend: sender))
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    profileHeader
                    statsSection
                    actionSection

                    if profileState == .friend {
                        recentMemoriesSection
                    }

                    messagesSection
                }
                .padding(.horizontal, 24)
                .padding(.top, showsCustomBackButton ? 88 : 32)
                .padding(.bottom, 48)
            }

            if showsCustomBackButton {
                topBar
            }
        }
        .navigationTitle(showsCustomBackButton ? "" : L10n.Friends.friendRequest)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.startListening()
        }
        .onDisappear {
            viewModel.stopListening()
        }
        .fullScreenCover(isPresented: $viewModel.isFriendMapPresented) {
            UserMapView(user: viewModel.friend)
        }
        .sheet(item: $selectedMemoryForDetails) { memory in
            UserMemoryDetailsView(memory: memory)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 40, height: 40)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(L10n.Friends.friendRequest)
                .font(.system(size: 20, weight: .semibold))
                .tracking(-0.5)
                .foregroundStyle(Color.appPrimary)
                .lineLimit(1)

            Spacer()

            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .background(Color.appBackground.opacity(0.8))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.black.opacity(0.03))
                .frame(height: 1)
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 16) {
            avatar

            VStack(spacing: 6) {
                Text(viewModel.friend.username)
                    .font(.system(size: 34, weight: .bold))
                    .tracking(-0.8)
                    .foregroundStyle(Color.appTitle)
                    .multilineTextAlignment(.center)

                Text(viewModel.friend.email)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
    }

    private var avatar: some View {
        Text(String(viewModel.friend.username.prefix(1)).uppercased())
            .font(.system(size: 44, weight: .bold))
            .foregroundStyle(Color.appPrimary)
            .frame(width: 112, height: 112)
            .background(Color.friendProfileAvatarBackground)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            }
            .shadow(color: Color.appTitle.opacity(0.08), radius: 24, x: 0, y: 10)
    }

    private var statsSection: some View {
        HStack(spacing: 14) {
            statCard(value: "\(viewModel.memoriesCount)", title: L10n.Friends.memories)
            statCard(value: "\(viewModel.countriesCount)", title: L10n.Friends.countries)
            statCard(value: "\(viewModel.citiesCount)", title: L10n.Friends.cities)
        }
        .padding(.top, 12)
    }

    private func statCard(value: String, title: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.appPrimary)

            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(1)
                .foregroundStyle(Color.appSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(Color.appSurface.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.appTitle.opacity(0.04), radius: 18, x: 0, y: 8)
    }

    private var actionSection: some View {
        VStack(spacing: 16) {
            switch profileState {
            case .pending:
                pendingActions

            case .friend:
                friendActions

            case .notFriend:
                notFriendActions
            }
        }
        .padding(.top, 8)
    }

    private var pendingActions: some View {
        VStack(spacing: 12) {
            Button {
                acceptRequest()
            } label: {
                HStack(spacing: 8) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(Color.appOnPrimary)
                    } else {
                        Image(systemName: "checkmark")
                            .font(.system(size: 15, weight: .semibold))

                        Text(L10n.Friends.accept)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .foregroundStyle(Color.appOnPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.appPrimary)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)

            Button {
                rejectRequest()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))

                    Text(L10n.Friends.reject)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(Color.appError)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.friendRejectBackground)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)
        }
    }

    private var friendActions: some View {
        VStack(spacing: 16) {
            Button {
                viewModel.removeFriend()
                profileState = .notFriend
            } label: {
                Text(L10n.Friends.removeFriend)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.appError)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading)

            Button {
                viewModel.showFriendMap()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "map")
                        .font(.system(size: 18, weight: .semibold))

                    Text(L10n.Friends.showMap)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(Color.appPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.clear)
                .overlay {
                    Capsule()
                        .stroke(Color.appPrimary, lineWidth: 2)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var notFriendActions: some View {
        VStack(spacing: 16) {
            if !viewModel.isAlreadySent {
                Button {
                    viewModel.sendRequest()
                    viewModel.isAlreadySent = true
                } label: {
                    HStack(spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(Color.appOnPrimary)
                        } else {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 15, weight: .semibold))

                            Text(L10n.Friends.addFriend)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .foregroundStyle(Color.appOnPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.appPrimary)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isLoading || viewModel.isAlreadySent)
            }
        }
    }

    private var recentMemoriesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(L10n.Memories.recentArchive)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.appTitle)

                Spacer()

                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color.appPrimary)
                }
            }

            if viewModel.memories.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "map")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(Color.appPrimary.opacity(0.7))

                    Text(L10n.Memories.emptyFeed)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.appSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(28)
                .background(Color.appSurface.opacity(0.75))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            } else {
                ForEach(viewModel.memories.prefix(3)) { memory in
                    memoryRow(memory)
                        .onTapGesture {
                            selectedMemoryForDetails = memory
                        }
                }
            }
        }
        .padding(.top, 8)
    }

    private func memoryRow(_ memory: Memory) -> some View {
        HStack(spacing: 14) {
            RemoteMemoryImage(
                urlString: memory.primaryPhotoURL ?? "",
                fallbackImageName: "StartLandscape"
            )
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(displayTitle(for: memory))
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.appTitle)
                    .lineLimit(1)

                Text(memory.placeName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appSecondary)
                    .lineLimit(1)

                Text(memory.visitDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
            }

            Spacer()
        }
        .padding(14)
        .background(Color.appSurface.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func displayTitle(for memory: Memory) -> String {
        let title = memory.title.trimmingCharacters(in: .whitespacesAndNewlines)

        if !title.isEmpty {
            return title
        }

        return memory.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var messagesSection: some View {
        VStack(spacing: 8) {
            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appPrimary)
                    .multilineTextAlignment(.center)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appError)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func acceptRequest() {
        guard !viewModel.isLoading else { return }

        viewModel.isLoading = true
        viewModel.errorMessage = nil
        viewModel.successMessage = nil

        Task {
            do {
                try await FriendService.shared.acceptRequest(request)

                await MainActor.run {
                    viewModel.isLoading = false
                    viewModel.successMessage = L10n.Friends.Message.accepted
                    profileState = .friend
                }
            } catch {
                await MainActor.run {
                    viewModel.isLoading = false
                    viewModel.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func rejectRequest() {
        guard !viewModel.isLoading else { return }

        viewModel.isLoading = true
        viewModel.errorMessage = nil
        viewModel.successMessage = nil

        Task {
            do {
                try await FriendService.shared.rejectRequest(request)

                await MainActor.run {
                    viewModel.isLoading = false
                    viewModel.successMessage = L10n.Friends.Message.rejected
                    viewModel.isAlreadySent = false
                    profileState = .notFriend
                }
            } catch {
                await MainActor.run {
                    viewModel.isLoading = false
                    viewModel.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

private extension Color {
    static let friendProfileAvatarBackground = Color(
        red: 209 / 255,
        green: 250 / 255,
        blue: 229 / 255
    ).opacity(0.5)

    static let friendRejectBackground = Color(
        red: 186 / 255,
        green: 26 / 255,
        blue: 26 / 255
    ).opacity(0.08)
}

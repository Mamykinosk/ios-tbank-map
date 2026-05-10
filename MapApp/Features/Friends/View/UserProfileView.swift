import SwiftUI
import MapboxMaps

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: FriendProfileViewModel
    @State private var selectedMemoryForDetails: Memory?
    
    @State private var sendDisabled: Bool

    let showsCustomBackButton: Bool

    init(user: FriendUser, showsCustomBackButton: Bool = true, sendDisabled: Bool) {
        _viewModel = State(initialValue: FriendProfileViewModel(friend: user))
        self.showsCustomBackButton = showsCustomBackButton
        self.sendDisabled = sendDisabled
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
        .navigationTitle(showsCustomBackButton ? "" : L10n.userTitle)
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
        .task {
            await viewModel.isFriendRequestAlreadySent()
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

            Text(L10n.userTitle)
                .font(.system(size: 20, weight: .semibold))
                .tracking(-0.5)
                .foregroundStyle(Color.appPrimary)
                .lineLimit(1)

            Spacer()

            Button {
                // settings later
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 40, height: 40)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
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
            if !sendDisabled && !viewModel.isAlreadySent {
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
                .disabled(viewModel.isLoading || sendDisabled || viewModel.isAlreadySent)
            }
            else if sendDisabled {
                Text(L10n.Friends.alreadyAdded)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.appAccent)
            }
        }
        .padding(.top, 8)
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
}

private extension Color {
    static let friendProfileAvatarBackground = Color(
        red: 209 / 255,
        green: 250 / 255,
        blue: 229 / 255
    ).opacity(0.5)
}

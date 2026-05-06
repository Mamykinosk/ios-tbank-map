import SwiftUI


struct SearchResultRow: View {
    let user: FriendUser
    let viewModel: FriendsViewModel
    let isSearchPresented: Bool
    let onSelect: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button {
                if viewModel.incomingRequests.contains(where: { $0.senderId == user.id }) { }
                else {
                    onSelect()
                }
            } label: {
                HStack(spacing: 14) {
                    avatar(for: user.username)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.username)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.appTitle)

                        Text(user.email)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.appSecondary)
                            .lineLimit(1)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer()

            if viewModel.isAlreadyFriend(user) {
                Text(L10n.Friends.friend)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
            } else if viewModel.isRequestAlreadySent(to: user) {
                Text(L10n.Friends.sent)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.appPlaceholder)
            } else if viewModel.incomingRequests.contains(where: { $0.senderId == user.id }) {
                
                let request = viewModel.incomingRequests.first(where: { $0.senderId == user.id } )!
                            
                Button {
                    viewModel.acceptRequest(request)
                    viewModel.friends.append(user)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(Color.appPrimary)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Button {
                    viewModel.rejectRequest(request)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.appError)
                        .frame(width: 34, height: 34)
                        .background(Color.friendRejectBackground)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
    
            } else {
                Button {
                    viewModel.sendRequest(to: user)
                } label: {
                    Text(L10n.Common.add)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .frame(height: 34)
                        .background(Color.appPrimary)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                //.disabled(viewModel.isLoading)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func avatar(for text: String) -> some View {
        let firstLetter = String(text.prefix(1)).uppercased()
        return Text(firstLetter.isEmpty ? "U" : firstLetter)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Color.appPrimary)
            .frame(width: 52, height: 52)
            .background(Color.friendAvatarBackground)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            }
    }
}

private extension Color {
    static let friendAvatarBackground = Color(red: 209 / 255, green: 250 / 255, blue: 229 / 255).opacity(0.5)
    static let friendRejectBackground = Color(red: 186 / 255, green: 26 / 255, blue: 26 / 255).opacity(0.08)
}

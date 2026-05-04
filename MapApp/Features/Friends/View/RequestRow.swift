import SwiftUI

struct RequestRow: View {
    let request: FriendRequest
    
    let acceptRequest: () -> Void
    let rejectRequest: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            avatar(senderName: request.sender?.username ?? "U")

            VStack(alignment: .leading, spacing: 4) {
                Text(request.sender?.username ?? String(localized: "friends.unknownUser"))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.appTitle)

                Text(request.sender?.email ?? String(localized: "friends.friendRequest"))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                acceptRequest()
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
                rejectRequest()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.appError)
                    .frame(width: 34, height: 34)
                    .background(Color.friendRejectBackground)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private func avatar(senderName: String) -> some View {
    let firstLetter = String(senderName.prefix(1)).uppercased()
  
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

private extension Color {
    static let friendRejectBackground = Color(red: 186 / 255, green: 26 / 255, blue: 26 / 255).opacity(0.08)
    static let friendAvatarBackground = Color(red: 209 / 255, green: 250 / 255, blue: 229 / 255).opacity(0.5)
}

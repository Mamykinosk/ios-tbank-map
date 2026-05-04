import SwiftUI

struct FriendRow: View {
    let friend: FriendUser
    let openProfile: () -> Void
    
    var body: some View {
        
        Button {
            openProfile()
        } label: {
            HStack(spacing: 14) {
                avatar(friendName: friend.username)

                VStack(alignment: .leading, spacing: 4) {
                    Text(friend.username)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.appTitle)

                    Text(friend.email)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.appSecondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "person")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.friendAvatarBackground)
                    .clipShape(Circle())
            }
            .padding(14)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private func avatar(friendName: String) -> some View {
    let firstLetter = String(friendName.prefix(1)).uppercased()
  
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
    static let friendAvatarBackground = Color(red: 209 / 255, green: 250 / 255, blue: 229 / 255).opacity(0.5)
}

import SwiftUI

struct AvatarView: View {
    let urlString: String?
    let title: String
    let size: CGFloat

    var body: some View {
        Group {
            if let urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color.white, lineWidth: 2)
        }
        .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
    }

    private var placeholder: some View {
        Circle()
            .fill(Color.appMuted)
            .overlay {
                Text(String(title.prefix(1)).uppercased())
                    .font(.system(size: size * 0.36, weight: .bold))
                    .foregroundStyle(Color.appPrimary)
            }
    }
}

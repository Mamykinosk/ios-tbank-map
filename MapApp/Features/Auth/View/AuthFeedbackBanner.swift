import SwiftUI

struct AuthFeedbackBanner: View {
    enum Tone {
        case error
        case success

        var backgroundColor: Color {
            switch self {
            case .error:
                return Color(red: 254 / 255, green: 237 / 255, blue: 237 / 255)
            case .success:
                return Color(red: 235 / 255, green: 247 / 255, blue: 238 / 255)
            }
        }

        var borderColor: Color {
            switch self {
            case .error:
                return Color(red: 186 / 255, green: 26 / 255, blue: 26 / 255).opacity(0.18)
            case .success:
                return Color(red: 67 / 255, green: 102 / 255, blue: 77 / 255).opacity(0.18)
            }
        }

        var foregroundColor: Color {
            switch self {
            case .error:
                return Color(red: 186 / 255, green: 26 / 255, blue: 26 / 255)
            case .success:
                return Color(red: 45 / 255, green: 75 / 255, blue: 63 / 255)
            }
        }

        var iconName: String {
            switch self {
            case .error:
                return "exclamationmark.circle.fill"
            case .success:
                return "checkmark.circle.fill"
            }
        }
    }

    let message: String
    let tone: Tone

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: tone.iconName)
                .font(.system(size: 14, weight: .semibold))

            Text(message)
                .font(.system(size: 13, weight: .medium))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(tone.foregroundColor)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(tone.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(tone.borderColor, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

import SwiftUI

struct AuthFeedbackBanner: View {
    enum Tone {
        case error
        case success

        var backgroundColor: Color {
            switch self {
            case .error:
                return .appErrorBackground
            case .success:
                return .appSuccessBackground
            }
        }

        var borderColor: Color {
            switch self {
            case .error:
                return .appError.opacity(0.18)
            case .success:
                return .appSecondaryAction.opacity(0.18)
            }
        }

        var foregroundColor: Color {
            switch self {
            case .error:
                return .appError
            case .success:
                return .appAccent
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

import SwiftUI

struct MemoryMapPinView: View {
    let memory: Memory
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.appSecondaryAction : Color.appPrimary)
                    .frame(width: isSelected ? 60 : 48, height: isSelected ? 60 : 48)
                    .shadow(color: .black.opacity(0.14), radius: 12, x: 0, y: 6)

                RemoteMemoryImage(urlString: memory.primaryPhotoURL ?? "", fallbackImageName: "StartLandscape")
                    .frame(width: isSelected ? 48 : 38, height: isSelected ? 48 : 38)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }

            Capsule()
                .fill(isSelected ? Color.appSecondaryAction : Color.appPrimary)
                .frame(width: 4, height: isSelected ? 14 : 10)
                .offset(y: -2)
        }
    }
}

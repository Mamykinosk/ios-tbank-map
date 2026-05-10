import SwiftUI
import MapboxMaps

struct UserMapView: View {
    @Environment(\.dismiss) private var dismiss

    let user: FriendUser

    @State private var viewModel = UserMapViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Map(viewport: $viewModel.viewport) {
                ForEvery(viewModel.memories) { memory in
                    MapViewAnnotation(coordinate: memory.coordinate) {
                        MemoryMapPinView(
                            memory: memory,
                            isSelected: viewModel.selectedMemory?.id == memory.id
                        )
                        .onTapGesture {
                            viewModel.selectedMemory = memory
                        }
                    }
                    .allowOverlap(true)
                    .priority(1)
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.appBackground.opacity(0.75),
                    Color.clear,
                    Color.clear,
                    Color.appBackground.opacity(0.75)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                topBar

                Spacer()

                if viewModel.memories.isEmpty && !viewModel.isLoading {
                    emptyCard
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
        }
        .task {
            viewModel.startListening(userId: user.id)
        }
        .onDisappear {
            viewModel.stopListening()
        }

        .sheet(item: $viewModel.selectedMemory) { memory in
            UserMemoryDetailsView(memory: memory)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appSurface.opacity(0.92))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(user.username)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.appTitle)

                Text(L10n.Friends.userMap)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.appSecondary)
            }
            .padding(.horizontal, 18)
            .frame(height: 44)
            .background(Color.appSurface.opacity(0.92))
            .clipShape(Capsule())

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var emptyCard: some View {
        Text(L10n.Friends.emptyUserMap)
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(Color.appSecondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(22)
            .background(Color.appSurface.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

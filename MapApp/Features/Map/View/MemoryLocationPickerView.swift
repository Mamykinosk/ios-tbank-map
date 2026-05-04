import SwiftUI
import MapboxMaps
import CoreLocation

struct MemoryLocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: MemoriesViewModel

    var body: some View {
        ZStack {
            Map(viewport: $viewModel.viewport) {
                Puck2D()

                ForEvery(viewModel.memories) { memory in
                    MapViewAnnotation(coordinate: memory.coordinate) {
                        MemoryMapPinView(
                            memory: memory,
                            isSelected: viewModel.selectedMemoryForDetails?.id == memory.id
                        )
                        .onTapGesture {
                            viewModel.selectedMemoryForDetails = memory
                        }
                    }
                    .allowOverlap(true)
                    .priority(1)
                }
            }
            .mapStyle(.standard)
            .onMapLongPressGesture { context in
                viewModel.pendingCoordinate = context.coordinate
                viewModel.draft = MemoryDraft(coordinate: context.coordinate)

                dismiss()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewModel.isAddMemoryPresented = true
                }
            }
            .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.black.opacity(0.35),
                    Color.clear,
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                topBar

                Spacer()

                instructionCard
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }
        }
        .sheet(item: $viewModel.selectedMemoryForDetails) { memory in
            MemoryDetailsView(viewModel: viewModel, memory: memory)
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                viewModel.pendingCoordinate = nil
                viewModel.draft.reset()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(L10n.Memories.chooseLocation)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.appTitle)
                .padding(.horizontal, 18)
                .frame(height: 44)
                .background(Color.white.opacity(0.9))
                .clipShape(Capsule())

            Spacer()

            Button {
                viewModel.focusOnUser()
            } label: {
                Image(systemName: "location")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var instructionCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "hand.tap")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.appPrimary)

            Text(L10n.Memories.longPressHint)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.appSecondary)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(18)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 24, x: 0, y: 8)
    }
}

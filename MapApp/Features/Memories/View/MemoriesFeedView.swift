import SwiftUI

struct MemoriesFeedView: View {
    @Binding var selectedTab: AppTab
    @Bindable var viewModel: MemoriesViewModel

    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    feedHeader

                    if viewModel.memories.isEmpty && !viewModel.isLoading {
                        emptyState
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.memories) { memory in
                                MemoryGridCard(memory: memory)
                                    .onTapGesture {
                                        viewModel.selectedMemoryForDetails = memory
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 96)
                .padding(.bottom, 190)
            }

            VStack {
                AppTopBar(
                    title: L10n.Memories.appTitle,
                    showsBackButton: false,
                    showsSettingsButton: false
                )

                Spacer()
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    AppFloatingAddButton {
                        viewModel.openLocationPicker()
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 128)
                }
            }

            VStack {
                Spacer()

                AppBottomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .fullScreenCover(isPresented: $viewModel.isLocationPickerPresented) {
            MemoryLocationPickerView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.isAddMemoryPresented) {
            AddMemoryView(viewModel: viewModel)
        }
        .sheet(item: $viewModel.selectedMemoryForDetails) { memory in
            MemoryDetailsView(viewModel: viewModel, memory: memory)
        }
    }

    private var feedHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.Memories.recentArchive)
                .font(.system(size: 11, weight: .bold))
                .tracking(2.2)
                .foregroundStyle(Color.appPrimary)

            HStack(alignment: .center) {
                Text(L10n.Memories.feedTitle)
                    .font(.system(size: 30, weight: .heavy))
                    .tracking(-1.1)
                    .foregroundStyle(Color.appTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Spacer()

                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.appSecondary)
                    .frame(width: 34, height: 30)
                    .background(Color.appFieldBackground)
                    .clipShape(Capsule())
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "map")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(Color.appPrimary.opacity(0.7))

            Text(L10n.Memories.emptyFeed)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

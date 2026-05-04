import SwiftUI
import MapboxMaps

struct MainMapView: View {
    @Binding var selectedTab: AppTab
    @Bindable var viewModel: MemoriesViewModel

    @State private var isMemorySearchPresented = false
    @State private var selectedSearchMemory: Memory?

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

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
                viewModel.prepareMarkerCreation(at: context.coordinate)
            }
            .ignoresSafeArea()

            mapOverlayGradient
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                topBar

                searchLine
                    .padding(.top, 10)
                    .padding(.horizontal, 20)

                Spacer()
            }

            bottomMapControls

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
        .sheet(isPresented: $isMemorySearchPresented) {
            memorySearchSheet
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var topBar: some View {
        ZStack {
            Text(L10n.Memories.appTitle)
                .font(.system(size: 20, weight: .semibold))
                .tracking(-0.5)
                .foregroundStyle(Color.appPrimary)

            HStack {
                Spacer()

                Button {
                    // Settings later
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.appPrimary)
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .background(Color.appBackground)
    }

    private var searchLine: some View {
        Button {
            isMemorySearchPresented = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.appPlaceholder)

                Text(L10n.Memories.searchPlaceholder)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.appPlaceholder)

                Spacer()

                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(Color.appPlaceholder)
            }
            .padding(.horizontal, 18)
            .frame(height: 60)
            .background(Color.white.opacity(0.96))
            .clipShape(Capsule())
            .shadow(color: Color.appTitle.opacity(0.05), radius: 18, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }

    private var bottomMapControls: some View {
        VStack {
            Spacer()

            HStack(alignment: .bottom, spacing: 12) {
                Spacer()

                VStack(spacing: 16) {
                    Button {
                        viewModel.focusOnUser()
                    } label: {
                        Image(systemName: "location")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Color.appPrimary)
                            .frame(width: 56, height: 56)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.06), radius: 30, x: 0, y: 8)
                    }
                    .buttonStyle(.plain)

                    AppFloatingAddButton {
                        viewModel.openLocationPicker()
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 128)
        }
    }

    private var memorySearchSheet: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    memorySearchField

                    if viewModel.filteredSearchMemories.isEmpty && !viewModel.searchText.isEmpty {
                        emptySearchView
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.filteredSearchMemories) { memory in
                                    memorySearchResultRow(memory)
                                }
                            }
                            .padding(.bottom, 24)
                        }
                    }

                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle(L10n.Memories.searchMemoriesTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedSearchMemory) { memory in
                MemoryDetailsView(viewModel: viewModel, memory: memory)
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .navigationBar)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.Common.clear) {
                        viewModel.clearMemorySearch()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        isMemorySearchPresented = false
                    }
                }
            }
        }
    }

    private var memorySearchField: some View {
        HStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.appPlaceholder)

            TextField(
                "",
                text: $viewModel.searchText,
                prompt: Text(L10n.Memories.searchPlaceholder)
                    .foregroundColor(Color.appPlaceholder)
            )
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Color.appTitle)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearMemorySearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.appPlaceholder)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 56)
        .background(Color.white.opacity(0.96))
        .clipShape(Capsule())
        .shadow(color: Color.appTitle.opacity(0.04), radius: 16, x: 0, y: 8)
    }

    private var emptySearchView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(Color.appPrimary.opacity(0.7))

            Text(L10n.Memories.noMemoriesFound)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.appTitle)

            Text(L10n.Memories.searchNoResultsHint)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color.appPlaceholder)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private func memorySearchResultRow(_ memory: Memory) -> some View {
        Button {
            selectedSearchMemory = memory
        } label: {
            HStack(spacing: 14) {
                RemoteMemoryImage(
                    urlString: memory.primaryPhotoURL ?? "",
                    fallbackImageName: "StartLandscape"
                )
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(displayTitle(for: memory))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.appTitle)
                        .lineLimit(1)

                    Text(memory.placeName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.appSecondary)
                        .lineLimit(1)

                    Text(memory.visitDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.appPrimary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.appPlaceholder)
            }
            .padding(14)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func displayTitle(for memory: Memory) -> String {
        let title = memory.title.trimmingCharacters(in: .whitespacesAndNewlines)

        if !title.isEmpty {
            return title
        }

        return memory.placeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var mapOverlayGradient: some View {
        LinearGradient(
            colors: [
                Color.appBackground.opacity(0.55),
                Color.appBackground.opacity(0.05),
                Color.clear,
                Color.appBackground.opacity(0.85)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

private extension Color {
    static let mapMutedText = Color(red: 120 / 255, green: 113 / 255, blue: 108 / 255)
}

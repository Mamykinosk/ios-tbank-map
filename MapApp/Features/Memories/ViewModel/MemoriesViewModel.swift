import Foundation
import CoreLocation
import FirebaseFirestore
import MapboxMaps
import Observation

@MainActor
@Observable
final class MemoriesViewModel {
    var memories: [Memory] = []

    var viewport: Viewport = .followPuck(
        zoom: 13,
        bearing: .heading,
        pitch: 0
    )

    var selectedMemoryForDetails: Memory?

    var pendingCoordinate: CLLocationCoordinate2D?
    var draft = MemoryDraft()

    var isLoading = false
    var isLocationPickerPresented = false
    var isAddMemoryPresented = false

    var errorMessage: String?
    var successMessage: String?

    // MARK: - Search

    var searchText = ""

    var filteredSearchMemories: [Memory] {
        let query = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !query.isEmpty else {
            return memories
        }

        return memories.filter { memory in
            memory.title.lowercased().contains(query)
            || memory.placeName.lowercased().contains(query)
            || memory.story.lowercased().contains(query)
        }
    }

    func clearMemorySearch() {
        searchText = ""
    }

    private var memoriesListener: ListenerRegistration?
    private var ownerId: String?

    // MARK: - Listening

    func startListening(ownerId: String) {
        stopListening()

        self.ownerId = ownerId
        isLoading = true
        errorMessage = nil
        successMessage = nil

        memoriesListener = MemoryService.shared.listenMemories(userId: ownerId) { [weak self] result in
            Task { @MainActor in
                guard let self else { return }

                self.isLoading = false

                switch result {
                case .success(let memories):
                    self.memories = memories.sorted {
                        $0.visitDate > $1.visitDate
                    }

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func stopListening() {
        memoriesListener?.remove()
        memoriesListener = nil
        ownerId = nil
    }

    // MARK: - Map Actions

    func focusOnUser() {
        viewport = .followPuck(
            zoom: 14,
            bearing: .heading,
            pitch: 0
        )
    }

    func openLocationPicker() {
        pendingCoordinate = nil
        draft = MemoryDraft()
        isLocationPickerPresented = true
    }

    func prepareMarkerCreation(at coordinate: CLLocationCoordinate2D) {
        pendingCoordinate = coordinate
        draft = MemoryDraft(coordinate: coordinate)
        isAddMemoryPresented = true
    }

    func closeAddMemory() {
        pendingCoordinate = nil
        draft.reset()
        isAddMemoryPresented = false
    }

    // MARK: - Draft

    func prepareDraftForAdd() {
        if draft.coordinate == nil {
            draft.coordinate = pendingCoordinate
        }
    }

    func saveDraft() {
        Task {
            _ = await createMemory()
        }
    }

    // MARK: - CRUD

    func createMemory() async -> Bool {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        if draft.coordinate == nil {
            draft.coordinate = pendingCoordinate
        }

        do {
            try await MemoryService.shared.createMemory(from: draft)

            isLoading = false
            successMessage = L10n.Message.memorySaved
            isAddMemoryPresented = false
            pendingCoordinate = nil
            draft.reset()

            return true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription

            return false
        }
    }

    func updateMemory(_ memory: Memory) async -> Bool {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        do {
            let updatedMemory = try await MemoryService.shared.updateMemoryAndReturn(
                memory,
                with: draft
            )

            isLoading = false
            successMessage = L10n.Message.memoryUpdated

            if let index = memories.firstIndex(where: { $0.id == updatedMemory.id }) {
                memories[index] = updatedMemory
            }

            if selectedMemoryForDetails?.id == updatedMemory.id {
                selectedMemoryForDetails = updatedMemory
            }

            return true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription

            return false
        }
    }

    func deleteMemory(_ memory: Memory) {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        Task {
            do {
                try await MemoryService.shared.deleteMemory(memory)

                await MainActor.run {
                    self.isLoading = false
                    self.successMessage = L10n.Message.memoryDeleted
                    self.memories.removeAll { $0.id == memory.id }

                    if self.selectedMemoryForDetails?.id == memory.id {
                        self.selectedMemoryForDetails = nil
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

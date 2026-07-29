// MARK: - DetailScreenViewModel.swift
// TV-Mami-Keenan
//
// Purpose: ViewModel for the show detail screen.
// Owns the view state and drives data loading from the service layer.
// All state mutations happen on the Main Actor to ensure safe UI updates.

import Foundation

// MARK: - DetailScreenViewState

enum DetailScreenViewState {
    case loading
    case success(ShowDetail)
    case error(String)
}

// MARK: - DetailScreenViewModel

@Observable
@MainActor
final class DetailScreenViewModel {

    // MARK: - Published State

    private(set) var state: DetailScreenViewState = .loading

    // MARK: - Dependencies

    private let service: TVMazeServiceProtocol
    private let showID: Int

    // MARK: - Initializer

    /// - Parameters:
    ///   - showID: The TVMaze ID of the show to load.
    ///   - service: The data service used to fetch the show detail.
    ///     Defaults to `TVMazeService()` for production use.
    ///     Inject a mock conforming to `TVMazeServiceProtocol` for unit testing.
    init(showID: Int, service: TVMazeServiceProtocol = TVMazeService()) {
        self.showID = showID
        self.service = service
    }

    // MARK: - Intents

    /// Fetches the show detail from the service and updates `state`.
    /// Transitions: `.loading` → `.success(ShowDetail)` or `.error(String)`.
    func loadShow() async {
        state = .loading
        do {
            let showDetail = try await service.fetchShowDetail(id: showID)
            state = .success(showDetail)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

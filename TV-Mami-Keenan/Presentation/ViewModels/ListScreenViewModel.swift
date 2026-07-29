// MARK: - ListScreenViewModel.swift
// TV-Mami-Keenan
//
// Purpose: ViewModel for the show list screen.
// Owns the view state and drives data loading from the service layer.
// All state mutations happen on the Main Actor to ensure safe UI updates.

import Foundation

// MARK: - ViewState

enum ViewState {
    case loading
    case success([Show])
    case error(String)
}

// MARK: - ListScreenViewModel

@Observable
@MainActor
final class ListScreenViewModel {

    // MARK: - Published State

    private(set) var state: ViewState = .loading

    // MARK: - Dependencies

    private let service: TVMazeServiceProtocol

    // MARK: - Initializer

    /// - Parameter service: The data service used to fetch shows.
    ///   Defaults to `TVMazeService()` for production use.
    ///   Inject a mock conforming to `TVMazeServiceProtocol` for unit testing.
    init(service: TVMazeServiceProtocol = TVMazeService()) {
        self.service = service
    }

    // MARK: - Intents

    /// Fetches the first page of shows from the service and updates `state`.
    /// Transitions: `.loading` → `.success([Show])` or `.error(String)`.
    func loadShows() async {
        state = .loading
        do {
            let shows = try await service.fetchShows(page: 0)
            state = .success(shows)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

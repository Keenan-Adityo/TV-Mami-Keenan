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

    /// True while an additional page is being fetched (not the first load).
    private(set) var isLoadingMore: Bool = false

    /// True when the API returns fewer results than a full page (no more pages).
    private(set) var hasReachedEnd: Bool = false

    // MARK: - Pagination

    private var currentPage: Int = 0

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

    /// Fetches page 0 and resets all pagination state.
    /// Transitions: `.loading` → `.success([Show])` or `.error(String)`.
    func loadShows() async {
        currentPage = 0
        hasReachedEnd = false
        state = .loading
        do {
            let shows = try await service.fetchShows(page: 0)
            hasReachedEnd = shows.isEmpty
            state = .success(shows)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    /// Appends the next page of shows to the existing list.
    /// No-ops if already loading more or the end of the catalogue has been reached.
    func loadMoreShows() async {
        guard !isLoadingMore, !hasReachedEnd,
              case .success(let currentShows) = state else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        let nextPage = currentPage + 1
        do {
            let newShows = try await service.fetchShows(page: nextPage)
            if newShows.isEmpty {
                hasReachedEnd = true
            } else {
                currentPage = nextPage
                state = .success(currentShows + newShows)
            }
        } catch {
            // Silently fail — the existing list remains intact.
        }
    }
}

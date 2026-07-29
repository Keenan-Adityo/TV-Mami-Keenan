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

    /// Primary state for the show detail card.
    private(set) var state: DetailScreenViewState = .loading

    /// Seasons fetched in parallel with the show detail. Empty until loaded.
    private(set) var seasons: [Season] = []

    /// Cast members fetched in parallel with the show detail. Empty until loaded.
    private(set) var cast: [CastMember] = []

    /// Episodes indexed by season ID. Populated on demand via `loadEpisodes(forSeasonID:)`.
    private(set) var episodesBySeason: [Int: [Episode]] = [:]

    /// Tracks which season IDs are currently being fetched, to prevent duplicate requests.
    private(set) var loadingSeasonIDs: Set<Int> = []

    // MARK: - Dependencies

    private let service: TVMazeServiceProtocol
    private let showID: Int

    // MARK: - Initializer

    /// - Parameters:
    ///   - showID: The TVMaze ID of the show to load.
    ///   - service: The data service used to fetch data.
    ///     Defaults to `TVMazeService()` for production use.
    ///     Inject a mock conforming to `TVMazeServiceProtocol` for unit testing.
    init(showID: Int, service: TVMazeServiceProtocol = TVMazeService()) {
        self.showID = showID
        self.service = service
    }

    // MARK: - Intents

    /// Fetches the show detail first, surfaces the UI immediately, then loads
    /// seasons and cast in the background without blocking the detail view.
    /// Transitions: `.loading` → `.success(ShowDetail)` or `.error(String)`.
    func loadShow() async {
        state = .loading
        do {
            // Phase 1: Fetch show detail and update the UI right away.
            let showDetail = try await service.fetchShowDetail(id: showID)
            state = .success(showDetail)

            // Phase 2: Seasons and cast fire concurrently in the background.
            // Neither can fail the main state — errors are swallowed silently.
            Task {
                if let fetchedSeasons = try? await service.fetchSeasons(showID: showID) {
                    seasons = fetchedSeasons
                }
            }
            Task {
                if let fetchedCast = try? await service.fetchCast(showID: showID) {
                    cast = fetchedCast
                }
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    /// Lazily fetches episodes for a given season the first time it is requested.
    /// Subsequent calls for the same season ID are no-ops (result is already cached).
    /// - Parameter seasonID: The TVMaze season ID to load episodes for.
    func loadEpisodes(forSeasonID seasonID: Int) async {
        // Skip if already fetched or currently in-flight.
        guard episodesBySeason[seasonID] == nil,
              !loadingSeasonIDs.contains(seasonID) else { return }

        loadingSeasonIDs.insert(seasonID)
        defer { loadingSeasonIDs.remove(seasonID) }

        do {
            let episodes = try await service.fetchEpisodes(seasonID: seasonID)
            episodesBySeason[seasonID] = episodes
        } catch {
            // Silently fail for episodes — the screen remains usable without them.
            episodesBySeason[seasonID] = []
        }
    }
}

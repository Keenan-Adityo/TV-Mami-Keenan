// MARK: - DetailScreenViewModelTests.swift
// TV-Mami-KeenanTests
//
// Purpose: Unit tests for `DetailScreenViewModel`.
// Uses `MockTVMazeService` to verify state transitions, concurrent loading of seasons and cast,
// and lazy episode caching.

import Testing
import Foundation
@testable import TV_Mami_Keenan

// MARK: - DetailScreenViewModelTests

@MainActor
struct DetailScreenViewModelTests {

    // MARK: - Initial State

    @Test("ViewModel initial state is .loading with empty seasons, cast, and episode cache")
    func initialState_defaults() {
        // Arrange
        let viewModel = DetailScreenViewModel(showID: 1, service: MockTVMazeService())

        // Assert
        guard case .loading = viewModel.state else {
            Issue.record("Expected initial state to be .loading but got \(viewModel.state)")
            return
        }
        #expect(viewModel.seasons.isEmpty)
        #expect(viewModel.cast.isEmpty)
        #expect(viewModel.episodesBySeason.isEmpty)
        #expect(viewModel.loadingSeasonIDs.isEmpty)
    }

    // MARK: - loadShow — Success

    @Test("loadShow transitions to .success with fetched ShowDetail")
    func loadShow_success() async {
        // Arrange
        let mock = MockTVMazeService()
        let expectedDetail = ShowDetail.stub(
            id: 42,
            name: "Severance",
            premiered: "2022-02-18",
            posterURL: URL(string: "https://example.com/severance.jpg"),
            backdropURL: URL(string: "https://example.com/severance_bg.jpg"),
            summary: "Mark leads a team of office workers whose memories have been surgically divided."
        )
        mock.stubbedShowDetail = expectedDetail
        let viewModel = DetailScreenViewModel(showID: 42, service: mock)

        // Act
        await viewModel.loadShow()

        // Assert — state is .success matching stubbed detail
        guard case .success(let detail) = viewModel.state else {
            Issue.record("Expected .success but got \(viewModel.state)")
            return
        }
        #expect(detail.id == 42)
        #expect(detail.name == "Severance")
        #expect(detail.premiered == "2022-02-18")
        #expect(detail.premieredYear == "2022")
        #expect(detail.summary?.contains("memories") == true)
    }

    // MARK: - loadShow — Failure

    @Test("loadShow transitions to .error state when the service fails with network error")
    func loadShow_networkFailure() async {
        // Arrange
        let mock = MockTVMazeService()
        mock.stubbedError = TVMazeServiceError.networkError(
            URLError(.notConnectedToInternet)
        )
        let viewModel = DetailScreenViewModel(showID: 1, service: mock)

        // Act
        await viewModel.loadShow()

        // Assert — state transitions to .error with localized description
        guard case .error(let message) = viewModel.state else {
            Issue.record("Expected .error but got \(viewModel.state)")
            return
        }
        #expect(!message.isEmpty)
    }

    @Test("loadShow transitions to .error state when HTTP request returns server error")
    func loadShow_httpError() async {
        // Arrange
        let mock = MockTVMazeService()
        mock.stubbedError = TVMazeServiceError.httpError(statusCode: 404)
        let viewModel = DetailScreenViewModel(showID: 999, service: mock)

        // Act
        await viewModel.loadShow()

        // Assert
        guard case .error(let message) = viewModel.state else {
            Issue.record("Expected .error but got \(viewModel.state)")
            return
        }
        #expect(!message.isEmpty)
    }

    // MARK: - loadEpisodes(forSeasonID:)

    @Test("loadEpisodes fetches and caches episodes for a given seasonID")
    func loadEpisodes_success() async {
        // Arrange
        let mock = MockTVMazeService()
        mock.stubbedEpisodes = [
            .stub(id: 101, name: "Pilot", season: 1, number: 1),
            .stub(id: 102, name: "Cat's in the Bag...", season: 1, number: 2)
        ]
        let viewModel = DetailScreenViewModel(showID: 1, service: mock)

        // Act
        await viewModel.loadEpisodes(forSeasonID: 10)

        // Assert
        let cachedEpisodes = viewModel.episodesBySeason[10]
        #expect(cachedEpisodes?.count == 2)
        #expect(cachedEpisodes?[0].name == "Pilot")
        #expect(cachedEpisodes?[1].name == "Cat's in the Bag...")
        #expect(mock.fetchEpisodesCallCount == 1)
        #expect(mock.fetchEpisodesSeasonIDArguments == [10])
    }
}

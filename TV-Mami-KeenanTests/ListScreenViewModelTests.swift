// MARK: - ListScreenViewModelTests.swift
// TV-Mami-KeenanTests
//
// Purpose: Unit tests for `ListScreenViewModel`.
// Uses `MockTVMazeService` to verify state transitions without network calls.

import Testing
import Foundation
@testable import TV_Mami_Keenan

// MARK: - ListScreenViewModelTests

@MainActor
struct ListScreenViewModelTests {

    // MARK: - loadShows — Success

    @Test("loadShows transitions to .success with returned shows")
    func loadShows_success() async throws {
        // Arrange
        let mock = MockTVMazeService()
        mock.stubbedShows = [
            .stub(id: 1, name: "Breaking Bad"),
            .stub(id: 2, name: "Better Call Saul")
        ]
        let viewModel = ListScreenViewModel(service: mock)

        // Act
        await viewModel.loadShows()

        // Assert — state is success with the expected shows
        guard case .success(let shows) = viewModel.state else {
            Issue.record("Expected .success but got \(viewModel.state)")
            return
        }
        #expect(shows.count == 2)
        #expect(shows[0].name == "Breaking Bad")
        #expect(shows[1].name == "Better Call Saul")
    }

    @Test("loadShows calls fetchShows with page 0")
    func loadShows_callsCorrectPage() async {
        // Arrange
        let mock = MockTVMazeService()
        let viewModel = ListScreenViewModel(service: mock)

        // Act
        await viewModel.loadShows()

        // Assert — service was called exactly once with page 0
        #expect(mock.fetchShowsCallCount == 1)
        #expect(mock.fetchShowsPageArguments == [0])
    }

    // MARK: - loadShows — Empty

    @Test("loadShows transitions to .success with an empty list when service returns no shows")
    func loadShows_emptyResult() async {
        // Arrange
        let mock = MockTVMazeService()
        mock.stubbedShows = []
        let viewModel = ListScreenViewModel(service: mock)

        // Act
        await viewModel.loadShows()

        // Assert — state is success but contains no shows
        guard case .success(let shows) = viewModel.state else {
            Issue.record("Expected .success but got \(viewModel.state)")
            return
        }
        #expect(shows.isEmpty)
    }

    // MARK: - loadShows — Failure

    @Test("loadShows transitions to .error when the service throws")
    func loadShows_networkFailure() async {
        // Arrange
        let mock = MockTVMazeService()
        mock.stubbedError = TVMazeServiceError.networkError(
            URLError(.notConnectedToInternet)
        )
        let viewModel = ListScreenViewModel(service: mock)

        // Act
        await viewModel.loadShows()

        // Assert — state is error with a non-empty message
        guard case .error(let message) = viewModel.state else {
            Issue.record("Expected .error but got \(viewModel.state)")
            return
        }
        #expect(!message.isEmpty)
    }

    @Test("loadShows transitions to .error when decoding fails")
    func loadShows_decodingFailure() async {
        // Arrange
        let mock = MockTVMazeService()
        mock.stubbedError = TVMazeServiceError.decodingError(
            NSError(domain: "test", code: -1)
        )
        let viewModel = ListScreenViewModel(service: mock)

        // Act
        await viewModel.loadShows()

        // Assert
        guard case .error(let message) = viewModel.state else {
            Issue.record("Expected .error but got \(viewModel.state)")
            return
        }
        #expect(!message.isEmpty)
    }

    // MARK: - Initial State

    @Test("ViewModel initial state is .loading before any load is triggered")
    func initialState_isLoading() {
        // Arrange & Assert
        let viewModel = ListScreenViewModel(service: MockTVMazeService())

        guard case .loading = viewModel.state else {
            Issue.record("Expected initial state to be .loading but got \(viewModel.state)")
            return
        }
    }

    // MARK: - Show Data Integrity

    @Test("loadShows preserves show rating and posterURL from service")
    func loadShows_preservesShowData() async {
        // Arrange
        let posterURL = URL(string: "https://example.com/show.jpg")
        let mock = MockTVMazeService()
        mock.stubbedShows = [.stub(id: 42, name: "Severance", posterURL: posterURL, rating: 8.7)]
        let viewModel = ListScreenViewModel(service: mock)

        // Act
        await viewModel.loadShows()

        // Assert
        guard case .success(let shows) = viewModel.state, let show = shows.first else {
            Issue.record("Expected .success with at least one show")
            return
        }
        #expect(show.id == 42)
        #expect(show.name == "Severance")
        #expect(show.posterURL == posterURL)
        #expect(show.rating == 8.7)
        #expect(show.ratingDisplayString == "8.7")
    }
}

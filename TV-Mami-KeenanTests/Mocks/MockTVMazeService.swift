// MARK: - MockTVMazeService.swift
// TV-Mami-KeenanTests
//
// Purpose: A configurable test double for `TVMazeServiceProtocol`.
// Inject into ViewModels during unit tests to simulate success,
// empty, and failure scenarios without making real network calls.

import Foundation
@testable import TV_Mami_Keenan

// MARK: - MockTVMazeService

final class MockTVMazeService: TVMazeServiceProtocol {

    // MARK: - Stubs

    /// Set to the array of `Show` objects returned by `fetchShows`.
    var stubbedShows: [Show] = []

    /// Set to the `ShowDetail` returned by `fetchShowDetail`.
    var stubbedShowDetail: ShowDetail = .stub()

    /// When non-nil, both fetch methods throw this error instead.
    var stubbedError: Error?

    // MARK: - Call Tracking

    /// Number of times `fetchShows(page:)` was called.
    private(set) var fetchShowsCallCount: Int = 0

    /// The page values passed to each `fetchShows(page:)` call.
    private(set) var fetchShowsPageArguments: [Int] = []

    /// Number of times `fetchShowDetail(id:)` was called.
    private(set) var fetchShowDetailCallCount: Int = 0

    /// The ID values passed to each `fetchShowDetail(id:)` call.
    private(set) var fetchShowDetailIDArguments: [Int] = []

    // MARK: - TVMazeServiceProtocol

    func fetchShows(page: Int) async throws -> [Show] {
        fetchShowsCallCount += 1
        fetchShowsPageArguments.append(page)

        if let error = stubbedError { throw error }
        return stubbedShows
    }

    func fetchShowDetail(id: Int) async throws -> ShowDetail {
        fetchShowDetailCallCount += 1
        fetchShowDetailIDArguments.append(id)

        if let error = stubbedError { throw error }
        return stubbedShowDetail
    }
}

// MARK: - Show + Stub Factory

extension Show {
    /// Returns a fully-populated `Show` suitable for use in tests.
    static func stub(
        id: Int = 1,
        name: String = "Breaking Bad",
        posterURL: URL? = URL(string: "https://example.com/poster.jpg"),
        rating: Double? = 9.5
    ) -> Show {
        Show(id: id, name: name, posterURL: posterURL, rating: rating)
    }
}

// MARK: - ShowDetail + Stub Factory

extension ShowDetail {
    /// Returns a fully-populated `ShowDetail` suitable for use in tests.
    static func stub(
        id: Int = 1,
        name: String = "Breaking Bad",
        premiered: String? = "2008-01-20",
        posterURL: URL? = URL(string: "https://example.com/poster.jpg"),
        backdropURL: URL? = nil,
        summary: String? = "A chemistry teacher becomes a drug lord."
    ) -> ShowDetail {
        ShowDetail(
            id: id,
            name: name,
            premiered: premiered,
            posterURL: posterURL,
            backdropURL: backdropURL,
            summary: summary
        )
    }
}

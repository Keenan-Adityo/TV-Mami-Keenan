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

    /// Set to the array of `Season` objects returned by `fetchSeasons`.
    var stubbedSeasons: [Season] = []

    /// Set to the array of `Episode` objects returned by `fetchEpisodes`.
    var stubbedEpisodes: [Episode] = []

    /// Set to the array of `CastMember` objects returned by `fetchCast`.
    var stubbedCast: [CastMember] = []

    /// When non-nil, any fetch method throws this error instead.
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

    /// Number of times `fetchSeasons(showID:)` was called.
    private(set) var fetchSeasonsCallCount: Int = 0

    /// The showID values passed to each `fetchSeasons(showID:)` call.
    private(set) var fetchSeasonsShowIDArguments: [Int] = []

    /// Number of times `fetchEpisodes(seasonID:)` was called.
    private(set) var fetchEpisodesCallCount: Int = 0

    /// The seasonID values passed to each `fetchEpisodes(seasonID:)` call.
    private(set) var fetchEpisodesSeasonIDArguments: [Int] = []

    /// Number of times `fetchCast(showID:)` was called.
    private(set) var fetchCastCallCount: Int = 0

    /// The showID values passed to each `fetchCast(showID:)` call.
    private(set) var fetchCastShowIDArguments: [Int] = []

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

    func fetchSeasons(showID: Int) async throws -> [Season] {
        fetchSeasonsCallCount += 1
        fetchSeasonsShowIDArguments.append(showID)

        if let error = stubbedError { throw error }
        return stubbedSeasons
    }

    func fetchEpisodes(seasonID: Int) async throws -> [Episode] {
        fetchEpisodesCallCount += 1
        fetchEpisodesSeasonIDArguments.append(seasonID)

        if let error = stubbedError { throw error }
        return stubbedEpisodes
    }

    func fetchCast(showID: Int) async throws -> [CastMember] {
        fetchCastCallCount += 1
        fetchCastShowIDArguments.append(showID)

        if let error = stubbedError { throw error }
        return stubbedCast
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
        url: URL? = nil,
        name: String = "Breaking Bad",
        premiered: String? = "2008-01-20",
        posterURL: URL? = URL(string: "https://example.com/poster.jpg"),
        backdropURL: URL? = nil,
        summary: String? = "A chemistry teacher becomes a drug lord."
    ) -> ShowDetail {
        ShowDetail(
            id: id,
            url: url,
            name: name,
            premiered: premiered,
            posterURL: posterURL,
            backdropURL: backdropURL,
            summary: summary
        )
    }
}

// MARK: - Season + Stub Factory

extension Season {
    /// Returns a fully-populated `Season` suitable for use in tests.
    static func stub(
        id: Int = 1,
        url: URL? = nil,
        number: Int = 1,
        episodeOrder: Int? = 7,
        premiereDate: String? = "2008-01-20",
        endDate: String? = "2008-03-09",
        posterURL: URL? = nil,
        backdropURL: URL? = nil,
        summary: String? = "Season 1 summary"
    ) -> Season {
        Season(
            id: id,
            url: url,
            number: number,
            episodeOrder: episodeOrder,
            premiereDate: premiereDate,
            endDate: endDate,
            posterURL: posterURL,
            backdropURL: backdropURL,
            summary: summary
        )
    }
}

// MARK: - Episode + Stub Factory

extension Episode {
    /// Returns a fully-populated `Episode` suitable for use in tests.
    static func stub(
        id: Int = 1,
        url: URL? = nil,
        name: String = "Pilot",
        season: Int = 1,
        number: Int? = 1,
        airdate: String? = "2008-01-20",
        airtime: String? = "22:00",
        runtime: Int? = 58,
        rating: Double? = 8.5,
        thumbnailURL: URL? = nil,
        summary: String? = "Pilot episode summary"
    ) -> Episode {
        Episode(
            id: id,
            url: url,
            name: name,
            season: season,
            number: number,
            airdate: airdate,
            airtime: airtime,
            runtime: runtime,
            rating: rating,
            thumbnailURL: thumbnailURL,
            summary: summary
        )
    }
}

// MARK: - CastMember + Stub Factory

extension CastMember {
    /// Returns a fully-populated `CastMember` suitable for use in tests.
    static func stub(
        personID: Int = 1,
        personName: String = "Bryan Cranston",
        birthday: String? = "1956-03-07",
        photoURL: URL? = nil,
        characterID: Int = 1,
        characterName: String = "Walter White",
        characterImageURL: URL? = nil
    ) -> CastMember {
        CastMember(
            person: .init(id: personID, name: personName, birthday: birthday, photoURL: photoURL),
            character: .init(id: characterID, name: characterName, imageURL: characterImageURL)
        )
    }
}

// MARK: - TVMazeService.swift
// TV-Mami-Keenan
//
// Purpose: Concrete implementation of TVMazeServiceProtocol.
// Handles all URLSession-based networking, HTTP validation, and JSON decoding.
// Maps API DTOs to domain models before returning results — ViewModels never see DTOs.

import Foundation

// MARK: - TVMazeService

final class TVMazeService: TVMazeServiceProtocol {

    // MARK: - Private Properties

    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURL = URL(string: "https://api.tvmaze.com")!

    // MARK: - Initializer

    /// - Parameter session: The `URLSession` to use for requests. Defaults to `.shared`.
    ///   Injecting a custom session (e.g. with a mock `URLProtocol`) enables unit testing.
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        // TVMaze uses snake_case keys
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // MARK: - TVMazeServiceProtocol

    /// Fetches a paginated list of shows.
    /// The TVMaze API is zero-based: page 0 returns shows 1–250, page 1 returns 251–500, etc.
    func fetchShows(page: Int) async throws -> [Show] {
        let url = try buildURL(path: "/shows", queryItems: [
            URLQueryItem(name: "page", value: String(page))
        ])

        let (data, response) = try await performRequest(url: url)
        try validateHTTPResponse(response)

        let dtos = try decode([ShowDTO].self, from: data)
        return dtos.map { $0.toDomain() }
    }

    /// Fetches the full detail of a single show by its TVMaze ID.
    func fetchShowDetail(id: Int) async throws -> ShowDetail {
        let url = try buildURL(path: "/shows/\(id)")

        let (data, response) = try await performRequest(url: url)
        try validateHTTPResponse(response)

        let dto = try decode(ShowDetailDTO.self, from: data)
        return dto.toDomain()
    }

    /// Fetches the list of seasons for a given show.
    func fetchSeasons(showID: Int) async throws -> [Season] {
        let url = try buildURL(path: "/shows/\(showID)/seasons")

        let (data, response) = try await performRequest(url: url)
        try validateHTTPResponse(response)

        let dtos = try decode([SeasonDTO].self, from: data)
        return dtos.map { $0.toDomain() }
    }

    // MARK: - Private Helpers

    private func buildURL(path: String, queryItems: [URLQueryItem] = []) throws -> URL {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        guard let url = components?.url else {
            throw TVMazeServiceError.invalidURL
        }
        return url
    }

    private func performRequest(url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(from: url)
        } catch {
            throw TVMazeServiceError.networkError(error)
        }
    }

    private func validateHTTPResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TVMazeServiceError.unknownError
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw TVMazeServiceError.httpError(statusCode: httpResponse.statusCode)
        }
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw TVMazeServiceError.decodingError(error)
        }
    }
}

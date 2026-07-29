// MARK: - TVMazeServiceProtocol.swift
// TV-Mami-Keenan
//
// Purpose: Protocol abstraction for all TVMaze API calls.
// Injected into ViewModels via initializer injection to enable compile-time-safe
// unit testing with mock implementations.

import Foundation

// MARK: - TVMazeServiceProtocol

protocol TVMazeServiceProtocol {
    /// Fetches a paginated list of shows from the TVMaze API.
    /// - Parameter page: Zero-based page index.
    /// - Returns: An array of domain `Show` objects.
    /// - Throws: `TVMazeServiceError` on network or decoding failure.
    func fetchShows(page: Int) async throws -> [Show]

    /// Fetches the full detail of a single show from the TVMaze API.
    /// - Parameter id: The TVMaze show ID.
    /// - Returns: A domain `ShowDetail` object.
    /// - Throws: `TVMazeServiceError` on network or decoding failure.
    func fetchShowDetail(id: Int) async throws -> ShowDetail
}

// MARK: - TVMazeServiceError

enum TVMazeServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL could not be constructed."
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "The server returned an error with status code \(statusCode)."
        case .decodingError(let error):
            return "Failed to decode the server response: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

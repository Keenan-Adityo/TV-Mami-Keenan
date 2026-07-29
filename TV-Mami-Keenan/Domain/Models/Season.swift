// MARK: - Season.swift
// TV-Mami-Keenan
//
// Purpose: Domain model for a single season entry.
// Exposed to ViewModels and Views — fully decoupled from the API JSON structure.

import Foundation

// MARK: - Season (Domain Model)

struct Season: Identifiable, Hashable {
    let id: Int
    let url: URL?
    let number: Int
    let episodeOrder: Int?
    let premiereDate: String?
    let endDate: String?
    let posterURL: URL?
    let backdropURL: URL?
    let summary: String?

    // MARK: - Computed Helpers

    /// Display title, e.g. "Season 1".
    var displayTitle: String {
        "Season \(number)"
    }

    /// Episode count string, e.g. "6 episodes". Returns nil when unknown.
    var episodeCountString: String? {
        guard let episodeOrder else { return nil }
        return "\(episodeOrder) episode\(episodeOrder == 1 ? "" : "s")"
    }

    /// Premiere year string, e.g. "2013".
    var premiereYear: String? {
        premiereDate.flatMap { $0.split(separator: "-").first.map(String.init) }
    }
}

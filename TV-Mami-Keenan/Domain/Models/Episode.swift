// MARK: - Episode.swift
// TV-Mami-Keenan
//
// Purpose: Domain model for a single episode entry.
// Exposed to ViewModels and Views — fully decoupled from the API JSON structure.

import Foundation

// MARK: - Episode (Domain Model)

struct Episode: Identifiable, Hashable {
    let id: Int
    let url: URL?
    let name: String
    let season: Int
    let number: Int?
    let airdate: String?
    let airtime: String?
    let runtime: Int?
    let rating: Double?
    let thumbnailURL: URL?
    let summary: String?

    // MARK: - Computed Helpers

    /// Display title, e.g. "E1 · Episode 1". Falls back to just the name for specials (nil number).
    var displayTitle: String {
        if let number {
            return "E\(number) · \(name)"
        }
        return name
    }

    /// Formatted rating string, e.g. "8.4". Returns "N/A" when no rating is available.
    var ratingDisplayString: String {
        guard let rating else { return "N/A" }
        return String(format: "%.1f", rating)
    }

    /// Runtime formatted as "60 min".
    var runtimeDisplayString: String? {
        guard let runtime else { return nil }
        return "\(runtime) min"
    }
}

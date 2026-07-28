// MARK: - Show.swift
// TV-Mami-Keenan
//
// Purpose: Domain model for the Show entity.
// This is the type exposed to ViewModels and Views — completely decoupled from the API JSON.

import Foundation

// MARK: - Show (Domain Model)

struct Show: Identifiable, Hashable {
    let id: Int
    let name: String
    let posterURL: URL?
    let rating: Double?

    // MARK: - Computed helpers

    /// Formatted rating string, e.g. "8.5". Returns "N/A" when no rating is available.
    var ratingDisplayString: String {
        guard let rating else { return "N/A" }
        return String(format: "%.1f", rating)
    }
}

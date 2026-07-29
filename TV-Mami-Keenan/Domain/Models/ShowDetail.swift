// MARK: - ShowDetail.swift
// TV-Mami-Keenan
//
// Purpose: Domain model for the show detail screen.
// Exposed to ViewModels and Views — fully decoupled from the API JSON structure.

import Foundation

// MARK: - ShowDetail (Domain Model)

struct ShowDetail: Identifiable, Hashable {
    let id: Int
    let name: String
    let premiered: String?
    let posterURL: URL?
    let backdropURL: URL?
    let summary: String?

    // MARK: - Computed Helpers

    /// Premiered year string, e.g. "2013".
    var premieredYear: String? {
        premiered.flatMap { $0.split(separator: "-").first.map(String.init) }
    }
}

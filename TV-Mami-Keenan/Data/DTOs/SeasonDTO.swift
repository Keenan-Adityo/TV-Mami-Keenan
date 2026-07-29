// MARK: - SeasonDTO.swift
// TV-Mami-Keenan
//
// Purpose: Raw Codable DTO for the TVMaze /shows/{id}/seasons endpoint.
// Only decodes the fields the season list screen needs.
// Internal to the Data layer — never exposed to ViewModels or Views.

import Foundation

// MARK: - SeasonDTO

struct SeasonDTO: Decodable {
    let id: Int
    let url: String?
    let number: Int
    let episodeOrder: Int?
    let premiereDate: String?
    let endDate: String?
    let image: SeasonImageDTO?
    let summary: String?
}

// MARK: - SeasonImageDTO

struct SeasonImageDTO: Decodable {
    let medium: String?
    let original: String?
}

// MARK: - Domain Mapping

extension SeasonDTO {
    /// Maps this DTO to the `Season` domain model.
    /// This is the only crossing point from the Data layer to the rest of the app.
    func toDomain() -> Season {
        Season(
            id: id,
            url: url.flatMap { URL(string: $0) },
            number: number,
            episodeOrder: episodeOrder,
            premiereDate: premiereDate,
            endDate: endDate,
            posterURL: image?.medium.flatMap { URL(string: $0) },
            backdropURL: image?.original.flatMap { URL(string: $0) },
            summary: summary?.strippingHTML()
        )
    }
}

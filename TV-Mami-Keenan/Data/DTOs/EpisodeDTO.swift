// MARK: - EpisodeDTO.swift
// TV-Mami-Keenan
//
// Purpose: Raw Codable DTO for the TVMaze /seasons/{id}/episodes endpoint.
// Only decodes the fields the episode list screen needs.
// Internal to the Data layer — never exposed to ViewModels or Views.

import Foundation

// MARK: - EpisodeDTO

struct EpisodeDTO: Decodable {
    let id: Int
    let url: String?
    let name: String
    let season: Int
    let number: Int?
    let airdate: String?
    let airtime: String?
    let runtime: Int?
    let rating: EpisodeRatingDTO
    let image: EpisodeImageDTO?
    let summary: String?
}

// MARK: - EpisodeRatingDTO

struct EpisodeRatingDTO: Decodable {
    let average: Double?
}

// MARK: - EpisodeImageDTO

struct EpisodeImageDTO: Decodable {
    let medium: String?
    let original: String?
}

// MARK: - Domain Mapping

extension EpisodeDTO {
    /// Maps this DTO to the `Episode` domain model.
    /// This is the only crossing point from the Data layer to the rest of the app.
    func toDomain() -> Episode {
        Episode(
            id: id,
            url: url.flatMap { URL(string: $0) },
            name: name,
            season: season,
            number: number,
            airdate: airdate,
            airtime: airtime,
            runtime: runtime,
            rating: rating.average,
            thumbnailURL: image?.medium.flatMap { URL(string: $0) },
            summary: summary?.strippingHTML()
        )
    }
}

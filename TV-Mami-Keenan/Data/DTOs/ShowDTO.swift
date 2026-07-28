// MARK: - ShowDTO.swift
// TV-Mami-Keenan
//
// Purpose: Raw Codable DTO that mirrors the TVMaze /shows endpoint JSON.
// Only decodes the fields the app actually needs.
// Internal to the Data layer — never exposed to ViewModels or Views.

import Foundation

// MARK: - ShowDTO

struct ShowDTO: Decodable {
    let id: Int
    let name: String
    let image: ShowImageDTO?
    let rating: RatingDTO
}

// MARK: - RatingDTO

struct RatingDTO: Decodable {
    let average: Double?
}

// MARK: - ShowImageDTO

struct ShowImageDTO: Decodable {
    let medium: String?
    let original: String?
}

// MARK: - Domain Mapping

extension ShowDTO {
    /// Maps this DTO to the internal domain model.
    /// This is the only boundary between the Data layer and the rest of the app.
    func toDomain() -> Show {
        Show(
            id: id,
            name: name,
            posterURL: image?.medium.flatMap { URL(string: $0) },
            rating: rating.average
        )
    }
}

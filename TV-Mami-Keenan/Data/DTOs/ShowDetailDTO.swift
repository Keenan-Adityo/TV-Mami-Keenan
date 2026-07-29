// MARK: - ShowDetailDTO.swift
// TV-Mami-Keenan
//
// Purpose: Raw Codable DTO for the TVMaze /shows/{id} endpoint.
// Only decodes the fields the detail screen needs.
// Internal to the Data layer — never exposed to ViewModels or Views.

import Foundation

// MARK: - ShowDetailDTO

struct ShowDetailDTO: Decodable {
    let id: Int
    let name: String
    let premiered: String?
    let image: ShowDetailImageDTO?
    let summary: String?
}

// MARK: - ShowDetailImageDTO

struct ShowDetailImageDTO: Decodable {
    let medium: String?
    let original: String?
}

// MARK: - Domain Mapping

extension ShowDetailDTO {
    /// Maps this DTO to the `ShowDetail` domain model.
    /// This is the only crossing point from the Data layer to the rest of the app.
    func toDomain() -> ShowDetail {
        ShowDetail(
            id: id,
            name: name,
            premiered: premiered,
            posterURL: image?.medium.flatMap { URL(string: $0) },
            backdropURL: image?.original.flatMap { URL(string: $0) },
            summary: summary?.strippingHTML()
        )
    }
}

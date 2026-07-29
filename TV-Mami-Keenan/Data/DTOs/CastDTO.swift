// MARK: - CastDTO.swift
// TV-Mami-Keenan
//
// Purpose: Raw Codable DTOs for the TVMaze /shows/{id}/cast endpoint.
// Only decodes the fields the cast screen needs.
// Internal to the Data layer — never exposed to ViewModels or Views.

import Foundation

// MARK: - CastMemberDTO

/// Represents one entry in the cast array: a person playing a character.
struct CastMemberDTO: Decodable {
    let person: PersonDTO
    let character: CharacterDTO
}

// MARK: - PersonDTO

struct PersonDTO: Decodable {
    let id: Int
    let name: String
    let birthday: String?
    let image: CastImageDTO?
}

// MARK: - CharacterDTO

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let image: CastImageDTO?
}

// MARK: - CastImageDTO

struct CastImageDTO: Decodable {
    let medium: String?
    let original: String?
}

// MARK: - Domain Mapping

extension CastMemberDTO {
    /// Maps this DTO to the `CastMember` domain model.
    /// This is the only crossing point from the Data layer to the rest of the app.
    func toDomain() -> CastMember {
        CastMember(
            person: CastMember.Person(
                id: person.id,
                name: person.name,
                birthday: person.birthday,
                photoURL: person.image?.medium.flatMap { URL(string: $0) }
            ),
            character: CastMember.Character(
                id: character.id,
                name: character.name,
                imageURL: character.image?.medium.flatMap { URL(string: $0) }
            )
        )
    }
}

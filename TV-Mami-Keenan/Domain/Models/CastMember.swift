// MARK: - CastMember.swift
// TV-Mami-Keenan
//
// Purpose: Domain model for a single cast entry.
// Exposed to ViewModels and Views — fully decoupled from the API JSON structure.

import Foundation

// MARK: - CastMember (Domain Model)

struct CastMember: Identifiable, Hashable {

    /// The real-world actor.
    let person: Person

    /// The fictional character they portray.
    let character: Character

    // CastMember's identity is the combination of person + character
    // (the same person can appear twice playing different characters).
    var id: String { "\(person.id)-\(character.id)" }

    // MARK: - Nested Types

    struct Person: Hashable {
        let id: Int
        let name: String
        let birthday: String?
        let photoURL: URL?

        /// Birthday year string, e.g. "1976".
        var birthYear: String? {
            birthday.flatMap { $0.split(separator: "-").first.map(String.init) }
        }
    }

    struct Character: Hashable {
        let id: Int
        let name: String
        let imageURL: URL?
    }
}

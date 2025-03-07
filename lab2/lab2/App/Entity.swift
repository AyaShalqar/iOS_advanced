//
//  Entity.swift
//  lab2
//
//  Created by Dias Yerlan on 24.02.2025.
//

import Foundation

struct UserProfile: Hashable {
    let id: String
    let username: String
    let bio: String
    let profileImageURL: URL?

    // Hash only immutable properties to ensure stable hash values
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Equality based on unique ID
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.id == rhs.id
    }
}

struct Post: Hashable {
    let id: UUID
    let author: UserProfile
    let hashtags: [String]
    var content: String
    

    // Hashing only immutable properties ensures consistency
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Posts are equal if their unique IDs match
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}

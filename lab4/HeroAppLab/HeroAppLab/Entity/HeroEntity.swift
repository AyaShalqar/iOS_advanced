//
//  HeroEntity.swift
//  HeroAppLab
//
//  Created by Aknur Seidazym on 17.03.2025.
//

import Foundation

struct HeroEntity: Decodable {
    let id: Int
    let name: String
    let appearance: Appearance
    let images: HeroImage
    let biography: Biography
    let powerstats: powerstats
    
    var heroImageUrl: URL? {
        URL(string: images.sm)
    }

    struct Appearance: Decodable {
        let race: String?
    }

    struct HeroImage: Decodable {
        let sm: String
        let md: String
    }
    
    struct Biography: Decodable {
        let fullName: String?
        let placeOfBirth: String?
        let alignment: String?
    }
    
    struct powerstats: Decodable {
        let intelligence: Int?
        let strength: Int?
        let speed: Int?
        let durability: Int?
        let power: Int?
        let combat: Int?
    }
}

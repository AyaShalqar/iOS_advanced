//
//  HeroListModel.swift
//  HeroAppLab
//
//  Created by Aknur Seidazym on 17.03.2025.
//

import Foundation

struct HeroListModel: Identifiable {
    let id: Int
    let title: String
    let description: String
    let heroImage: URL?
    let biography: String
}

struct HeroDetailModel: Identifiable {
    let id: Int
    let name: String
    let race: String
    let heroImage: URL?
    let biography: String
    let powerstats: String
}

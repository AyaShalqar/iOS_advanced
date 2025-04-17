//
//  HeroDetailViewModel.swift
//  HeroAppLab
//
//  Created by Aknur Seidazym on 17.03.2025.
//
import Foundation
import SwiftUI

final class HeroDetailViewModel: ObservableObject {
    @Published private(set) var hero: HeroDetailModel?
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    private let service: HeroService
    private let heroId: Int
    
    init(service: HeroService, heroId: Int) {
        self.service = service
        self.heroId = heroId
    }
    
    func fetchHeroDetails() async {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        do {
            let heroes = try await service.fetchHeroes()
            
            if let hero = heroes.first(where: { $0.id == heroId }) {
                await MainActor.run {
                    self.hero = HeroDetailModel(
                        id: hero.id,
                        name: hero.name,
                        race: hero.appearance.race ?? "Unknown",
                        heroImage: hero.heroImageUrl,
                        biography: "Full Name: \(hero.biography.fullName ?? "-") Alignment: \(hero.biography.alignment ?? "-")",
                        powerstats: "Intelligence: \(hero.powerstats.intelligence ?? 0) \nStrength: \(hero.powerstats.strength ?? 0) \nSpeed: \(hero.powerstats.speed ?? 0)"
                        
                        
                        
                    )
                    self.isLoading = false
                }
            } else {
                await MainActor.run {
                    self.error = "Hero not found"
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}

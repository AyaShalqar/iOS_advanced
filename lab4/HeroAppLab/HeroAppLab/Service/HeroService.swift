//
//  HeroService.swift
//  HeroAppLab
//
//  Created by Aknur Seidazym on 17.03.2025.
//

import Foundation

protocol HeroService {
    func fetchHeroes() async throws -> [HeroEntity]
    func fetchHeroById(id: Int) async throws -> HeroEntity
}

struct HeroServiceImpl: HeroService {
    func fetchHeroes() async throws -> [HeroEntity] {
        let urlString = Constants.baseUrl + "all.json"
        guard let url = URL(string: urlString) else {
            throw HeroError.wrongUrl
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse?.statusCode ?? 0)

            let heroes = try JSONDecoder().decode([HeroEntity].self, from: data)
            return heroes
        } catch {
            print(error)
            throw HeroError.somethingWentWrong
        }
    }
    
    
    func fetchHeroById(id: Int) async throws -> HeroEntity {
            let urlString = "\(Constants.baseUrl)id/\(id).json"
            guard let url = URL(string: urlString) else {
                throw HeroError.wrongUrl
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse?.statusCode ?? 0)

                let hero = try JSONDecoder().decode(HeroEntity.self, from: data)
                return hero
            } catch {
                print(error)
                throw HeroError.somethingWentWrong
            }
        }
    
//    func fetchHeroById(id: Int) async throws -> HeroEntity {
//        // For now, we'll fetch all heroes and filter for the one we want
//        let heroes = try await fetchHeroes()
//        
//        guard let hero = heroes.first(where: { $0.id == id }) else {
//            throw HeroError.heroNotFound
//        }
//        
//        return hero
//    }

    
}

enum HeroError: Error {
    case wrongUrl
    case somethingWentWrong
}

private enum Constants {
    static let baseUrl: String = "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/"
}

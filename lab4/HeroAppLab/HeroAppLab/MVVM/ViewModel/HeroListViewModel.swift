//
//  HeroListViewModel.swift
//  HeroAppLab
//
//  Created by Aknur Seidazym on 17.03.2025.
//
import SwiftUI
import Combine

final class HeroListViewModel: ObservableObject {
    @Published private(set) var heroes: [HeroListModel] = []
    @Published private(set) var filteredHeroes: [HeroListModel] = []
    @Published var searchText: String = ""

    private let service: HeroService
    private let router: HeroRouter
    private var cancellables = Set<AnyCancellable>()

    init(service: HeroService, router: HeroRouter) {
        self.service = service
        self.router = router
        setupSearchBinding()
    }
    
    private func setupSearchBinding() {
            $searchText
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .sink { [weak self] searchTerm in
                    self?.filterHeroes(with: searchTerm)
                }
                .store(in: &cancellables)
        }
        
    private func filterHeroes(with searchTerm: String) {
        if searchTerm.isEmpty {
            filteredHeroes = heroes
        } else {
            filteredHeroes = heroes.filter { hero in
                hero.title.lowercased().contains(searchTerm.lowercased()) ||
                hero.description.lowercased().contains(searchTerm.lowercased())
            }
        }
    }
    
    func fetchHeroes() async {
        do {
            let heroesResponse = try await service.fetchHeroes()

            await MainActor.run {
                heroes = heroesResponse.map {
                    HeroListModel(
                        id: $0.id,
                        title: $0.name,
                        description: $0.appearance.race ?? "No Race",
                        heroImage: $0.heroImageUrl,
                        biography: $0.biography.fullName ?? "No Name"
                    )
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func routeToDetail(by id: Int) {
        router.showDetails(for: id)
    }
}

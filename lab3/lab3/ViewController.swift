import SwiftUI
import UIKit

// MARK: - Superhero Data Model
struct Superhero: Codable, Identifiable {
    let id: Int
    let name: String
    let powerstats: Powerstats
    let biography: Biography
    let appearance: Appearance
    let images: Images
}

struct Powerstats: Codable {
    let intelligence, strength, speed, durability, power, combat: Int
}

struct Biography: Codable {
    let fullName: String
    let publisher: String?
}

struct Appearance: Codable {
    let gender, race: String?
    let height, weight: [String]
}

struct Images: Codable {
    let lg: String
}

// MARK: - API Manager
class NetworkManager {
    static let shared = NetworkManager()
    private let apiURL = "https://akabab.github.io/superhero-api/api/all.json"
    
    func fetchHeroes(completion: @escaping (Result<[Superhero], Error>) -> Void) {
        guard let url = URL(string: apiURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let heroes = try JSONDecoder().decode([Superhero].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(heroes))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - SwiftUI View
struct HeroView: View {
    @State private var hero: Superhero?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let hero = hero {
                VStack {
                    AsyncImage(url: URL(string: hero.images.lg)) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 300)
                    
                    Text(hero.name).font(.largeTitle).bold()
                    Text(hero.biography.fullName)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("⚡ Intelligence: \(hero.powerstats.intelligence)")
                        Text("💪 Strength: \(hero.powerstats.strength)")
                        Text("⚡ Speed: \(hero.powerstats.speed)")
                        Text("🛡 Durability: \(hero.powerstats.durability)")
                        Text("🔥 Power: \(hero.powerstats.power)")
                        Text("⚔ Combat: \(hero.powerstats.combat)")
                        Text("🧑 Gender: \(hero.appearance.gender ?? "Unknown")")
                        Text("🏳 Race: \(hero.appearance.race ?? "Unknown")")
                        Text("📏 Height: \(hero.appearance.height.first ?? "N/A")")
                        Text("⚖ Weight: \(hero.appearance.weight.first ?? "N/A")")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }
            
            Button("Get Random Hero") {
                fetchRandomHero()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear { fetchRandomHero() }
    }
    
    func fetchRandomHero() {
        isLoading = true
        NetworkManager.shared.fetchHeroes { result in
            isLoading = false
            switch result {
            case .success(let heroes):
                hero = heroes.randomElement()
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

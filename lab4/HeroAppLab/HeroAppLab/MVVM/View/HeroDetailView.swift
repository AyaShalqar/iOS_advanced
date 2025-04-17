//
//  HeroDetailView.swift
//  HeroAppLab
//
//  Created by Aknur Seidazym on 17.03.2025.
//
import SwiftUI

struct HeroDetailView: View {
    @StateObject var viewModel: HeroDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.isLoading {
                    loadingView()
                } else if let error = viewModel.error {
                    errorView(message: error)
                } else if let hero = viewModel.hero {
                    heroDetailContent(hero: hero)
                } else {
                    Text("No hero data available")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.hero?.name ?? "Hero Detail")
        .task {
            await viewModel.fetchHeroDetails()
        }
    }
}

extension HeroDetailView {
    @ViewBuilder
    private func loadingView() -> some View {
        VStack {
            ProgressView()
            Text("Loading hero details...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Error loading hero details")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.fetchHeroDetails()
                }
            }
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    @ViewBuilder
    private func heroDetailContent(hero: HeroDetailModel) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            AsyncImage(url: hero.heroImage) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                case .failure(_):
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .frame(width: 200, height: 200)
                case .empty:
                    ProgressView()
                        .frame(width: 200, height: 200)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            
            // Hero details
            Group {
                Text(hero.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Race:")
                    Text(hero.race)
                        .font(.body)
                }
                
                Text(hero.biography)
                    .font(.body)
                
                HStack {
                    Text("Powerstats:")
                    Text(hero.powerstats)
                        .font(.body)
                }
                

                
                
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

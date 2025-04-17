//
//  HeroListView.swift
//  HeroAppLab
//
//  Created by Aknur Seidazym on 17.03.2025.
//

import SwiftUI

struct HeroListView: View {
    @StateObject var viewModel: HeroListViewModel

    var body: some View {
        VStack {
            Text("Hero List")
                .font(.largeTitle)
            
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)

            Divider()
                .padding(.bottom, 16)
            
            listOfHeroes()


            Spacer()
        }
        .task {
            await viewModel.fetchHeroes()
        }
    }
}

extension HeroListView {
    @ViewBuilder
    private func listOfHeroes() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.filteredHeroes) { model in
                    heroCard(model: model)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                    Divider()
                }
            }
        }
    }

    @ViewBuilder
    private func heroCard(model: HeroListModel) -> some View {
        HStack {
            AsyncImage(url: model.heroImage) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.trailing, 16)
                default:
                    Color.gray
                        .frame(width: 100, height: 100)
                        .padding(.trailing, 16)
                }
            }

            VStack(alignment: .leading) {
                Text(model.title)
                Text(model.description)
                Text("Full Name: \(model.biography)")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            print("Tapped \(model.id)")
            viewModel.routeToDetail(by: model.id)
        }
    }
}
// Create a new SearchBar component
struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search heroes", text: $text)
                .focused($isFocused)
                .foregroundColor(.primary)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
        .padding(.vertical, 8)
    }
}

//
//  ContentView.swift
//  FiveImages
//
//  Created by Aknur Seidazym on 02.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ImagesViewModel = ImagesViewModel()
    
    // Two-column grid
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack {
            Text("Pinterest")
                .font(.title)
                .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(viewModel.images) { model in
                        model.image
                            .resizable()
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
                .padding(8)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            
            Button("Get 5 Images") {
                viewModel.getImages()
            }
            .padding()
            .buttonStyle(.bordered)
            .disabled(viewModel.isLoading)
        }
        .onAppear {
            if viewModel.images.isEmpty {
                viewModel.getImages()
            }
        }
    }
}

#Preview {
    ContentView(viewModel: ImagesViewModel())
}

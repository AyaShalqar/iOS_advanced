//
//  ImagesViewModel.swift
//  FiveImages
//
//  Created by Aknur Seidazym on 02.04.2025.
//

import Foundation
import SwiftUI

final class ImagesViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var isLoading: Bool = false
    
    func getImages() {
        guard !isLoading else { return }
                
        isLoading = true
        var tempImages: [ImageModel] = []
        let group = DispatchGroup()

        let urlStrings: [String] = (0...4).map { _ in
            "https://picsum.photos/id/\(Int.random(in: 0...1000))/500"
        }

        for url in urlStrings {
            group.enter()
            downloadImage(urlString: url) { model in
                if let model = model {
                    tempImages.append(model)
                }
                group.leave()
            }
        }
        
        // Asynchronous UI update after all downloads completed
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.images += tempImages
            self.isLoading = false // UI update: hide loading state
            
            if tempImages.count < 5 {
                print("Warning: Only fetched \(tempImages.count) images instead of 5")
            }
        }
        
    }
    
    private func downloadImage(urlString: String, completion: @escaping (ImageModel?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }

            if let safeData = data {
                guard let image = UIImage(data: safeData) else {
                    print("Cannot create image")
                    completion(nil)
                    return
                }

                let convertedImage = Image(uiImage: image)
                let model = ImageModel(image: convertedImage)
                completion(model)
            }
        }
        .resume()
    }
}

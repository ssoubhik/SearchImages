//
//  ImageLoaderViewModel.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//
import SwiftUI

// MARK: - Image Loading Error Enumeration

enum ImageLoadingError: Error {
    case badRequest
    case unsupportedImage
    case badUrl
}

// MARK: - Image Loader View Model

@MainActor
class ImageLoaderViewModel: ObservableObject {
    
    @Published var uiImage: UIImage?
    private static let cache = NSCache<NSString, UIImage>()
    
    func fetchImage(_ urlString: String) async throws {
        
        guard let url = URL(string: urlString) else {
            throw ImageLoadingError.badUrl
        }
        
        let request = URLRequest(url: url)
        
        // check in cache
        if let cachedImage = Self.cache.object(forKey: url.absoluteString as NSString) {
            uiImage = cachedImage
        } else {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw ImageLoadingError.badRequest
            }
            
            guard let image = UIImage(data: data) else {
                throw ImageLoadingError.unsupportedImage
            }
            
            // store it in the cache
            Self.cache.setObject(image, forKey: url.absoluteString as NSString)
            uiImage = image
        }
    }
}

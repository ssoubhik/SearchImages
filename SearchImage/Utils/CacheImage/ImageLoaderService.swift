//
//  ImageLoaderService.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 24/09/22.
//

import SwiftUI

// MARK: - Image Loader Service Protocol

protocol ImageLoaderService {
    func fetchImage(_ urlString: String) async throws -> UIImage?
}

// MARK: - Search Service Implementation

final class ImageLoaderServiceImpl: ImageLoaderService {
    private static let cache = NSCache<NSString, UIImage>()
    
    func fetchImage(_ urlString: String) async throws -> UIImage? {
        // url session
        let urlSession = URLSession.shared
        
        // url
        guard let url = URL(string: urlString) else {
            throw ImageLoadingError.badUrl
        }
        
        // url request
        let request = URLRequest(url: url)
        
        // check in cache
        if let cachedImage = Self.cache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        } else {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw ImageLoadingError.badRequest
            }
            
            guard let image = UIImage(data: data) else {
                throw ImageLoadingError.unsupportedImage
            }
            
            // store it in the cache
            Self.cache.setObject(image, forKey: url.absoluteString as NSString)
            return image
        }
    }
}

// MARK: - Image Loading Error Enumeration

enum ImageLoadingError: Error {
    case badRequest
    case unsupportedImage
    case badUrl
}

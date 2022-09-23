//
//  SearchService.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//

import Foundation

// MARK: - Search Service Protocol

protocol SearchService {
    func fetchSearchResults(_ searchTerm: String) async throws -> [Result]
}

// MARK: - Search Service Implementation

final class SearchServiceImpl: SearchService {
    func fetchSearchResults(_ searchTerm: String) async throws -> [Result] {
        // url session
        let urlSession = URLSession.shared
        
        // url query items
        let queryItems = [
            URLQueryItem(name: "key", value: APIConstants.key),
            URLQueryItem(name: "q", value: validatedSearchTerm(searchTerm)),
            URLQueryItem(name: "image_type", value: APIConstants.imageType)
        ]
        
        // url components
        var urlComponents = URLComponents(string: APIConstants.baseURl)
        urlComponents?.queryItems = queryItems
        
        // url
        guard let url = urlComponents?.url else {
            return []
        }
        
        let (data, _) = try await urlSession.data(from: url)
        let decodedData = try JSONDecoder().decode(SearchResult.self, from: data)
        
        return decodedData.results ?? []
    }
    
    func validatedSearchTerm(_ searchTerm: String) -> String {
        // check if text contains more then one word separated by space
        let textComponents = searchTerm.components(separatedBy: " ")
        
        // we replace space with plus to validate the string for the search url
        return textComponents.joined(separator: "+")
    }
}

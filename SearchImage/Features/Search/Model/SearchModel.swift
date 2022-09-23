//
//  SearchModel.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//

import Foundation

// MARK: - SearchResult Model

struct SearchResult: Decodable {
    let results: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case results = "hits"
    }
}

// MARK: - Result Model

struct Result: Decodable, Identifiable {
    let id: Int?
    let largeImageURL: String?
}

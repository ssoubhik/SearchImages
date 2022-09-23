//
//  SearchViewModel.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//

import Foundation

// MARK: - Search View Model Protocol

protocol SearchViewModel: ObservableObject {
    func getSearchResults(searchTerm: String) async
}

// MARK: - Search View Model Implementaion

@MainActor
final class SearchViewModelImpl: SearchViewModel {
    enum State {
        case loading
        case success(data: [Result])
    }
    
    @Published private(set) var state: State = .loading
    @Published var errorHandler = ErrorHandler(isPresented: false, errorDescription: "")
    
    private let service: SearchService
    
    init(service: SearchService) {
        self.service = service
    }
    
    func getSearchResults(searchTerm: String) async {
        do {
            let searchResults = try await service.fetchSearchResults(searchTerm)
            self.state = .success(data: searchResults)
        } catch {
            // show error alert
            self.errorHandler.isPresented = true
            self.errorHandler.errorDescription = error.localizedDescription
        }
    }
}

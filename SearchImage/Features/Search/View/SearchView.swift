//
//  SearchView.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//

import SwiftUI

// MARK: - Search View

struct SearchView: View {
    @StateObject private var searchVM = SearchViewModelImpl(service: SearchServiceImpl())

    @State private var searchTerm = ""
    @State private var isNavigationActive = false

    var body: some View {
        NavigationView {
            VStack {
                // search for photos text
                Text(StaticText.searchPhotos)

                // search bar
                TextField(StaticText.searchBarPlaceholder, text: $searchTerm)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                // programatic navigation to gallery view
                NavigationLink(isActive: $isNavigationActive) {
                    // gallery view
                    GalleryView(searchVM: searchVM)
                } label: {
                    // search button
                    Button(StaticText.searchButtonLabel) {
                        // navigation active
                        isNavigationActive = true

                        // API Call: fetching search results
                        Task {
                            await searchVM.getSearchResults(searchTerm: searchTerm)
                        }
                    }
                }
                .disabled(searchTerm.isBlank)
            }
            .navigationTitle(StaticText.searchTitle)
            .navigationBarTitleDisplayMode(.inline)
            .alert(StaticText.errorAlertTitle, isPresented: $searchVM.errorHandler.isPresented) {
                // alert cancel button
                Button(StaticText.okayButtonLabel, role: .cancel) {
                    isNavigationActive = false
                }
            } message: {
                // error description
                Text(searchVM.errorHandler.errorDescription)
            }
        }
    }
}

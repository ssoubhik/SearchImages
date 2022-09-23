//
//  GalleryView.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//

import SwiftUI

// MARK: - Gallery View

struct GalleryView: View {
    @ObservedObject var searchVM: SearchViewModelImpl
    
    // grid columns
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        Group {
            switch searchVM.state {
            case .loading:
                ProgressView()
            case .success(let data):
                if data.isEmpty {
                    // no results found
                    Text(StaticText.noResults)
                } else {
                    ScrollView {
                        // image grid
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(data) { result in
                                // url image view
                                URLImage(urlString: result.largeImageURL ?? "")
                            }
                        }
                    }
                    
                }
            }
        }
        .navigationTitle(StaticText.galleryTitle)
    }
}

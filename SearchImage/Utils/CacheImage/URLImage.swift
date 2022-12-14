//
//  URLImage.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//

import SwiftUI

// MARK: - URL Image View

struct URLImage: View {
    @StateObject private var imageLoaderVM = ImageLoaderViewModelImpl(service: ImageLoaderServiceImpl())
    
    let urlString: String
    
    var body: some View {
        GeometryReader { proxy in
            if let uiImage = imageLoaderVM.uiImage {
                // image view
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: proxy.size.width, height: proxy.size.height)
            } else {
                // image loading view
                ProgressView()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .background {
                        Color(uiColor: UIColor.secondarySystemBackground)
                    }
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .task {
            // downloading image from url
            await imageLoaderVM.loadImage(urlString)
        }
    }
}

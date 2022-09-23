//
//  ImageLoaderViewModel.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//
import SwiftUI

// MARK: - Image Loader View Model Protocol

protocol ImageLoaderViewModel: ObservableObject {
    func loadImage(_ urlString: String) async
}

// MARK: - Image Loader View Model Implementation

@MainActor
final class ImageLoaderViewModelImpl: ImageLoaderViewModel {
    @Published var uiImage: UIImage?
    
    private let service: ImageLoaderService
    
    init(service: ImageLoaderService) {
        self.service = service
    }
    
    func loadImage(_ urlString: String) async {
        do {
            // set uiimage
            self.uiImage = try await service.fetchImage(urlString)
        } catch {
            // print errors in console
            print(error)
        }
    }
}

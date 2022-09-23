//
//  StringExtension.swift
//  SearchImage
//
//  Created by Soubhik Sarkhel on 23/09/22.
//

import Foundation

// MARK: - String Extension

extension String {
    // check for blank string
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

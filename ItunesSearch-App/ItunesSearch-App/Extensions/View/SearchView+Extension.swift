//
//  SearchViewModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension SearchView{
    
    func changeImageURL(_ urlString: String, dimension dimensionValue: Int) -> String? {
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        if urlComponents.path.hasSuffix("/100x100bb.jpg") {
            urlComponents.path = urlComponents.path.replacingOccurrences(of: "/100x100bb.jpg", with: "/\(dimensionValue)x\(dimensionValue)bb.jpg")
            return urlComponents.string
        } else {
            return urlComponents.string
        }
    }
    
    func hapticFeedbackHeavy() {
        hapticHeavy.prepare()
        hapticHeavy.impactOccurred(intensity: 1.0)
    }
    
    func hapticFeedbackSoft() {
        hapticSoft.prepare()
        hapticSoft.impactOccurred(intensity: 1.0)
    }
}

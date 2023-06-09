//
//  SearchViewModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 8.05.2023.
//

import Foundation

extension SearchVM{
   
    func changeImageURL(_ urlString: String, dimension dimensionValue: Int) -> String? {
        
        guard var urlComponents = URLComponents(string: urlString) else { return nil }
        if urlComponents.path.hasSuffix(HardCoded.dimensionHundred.get()) {
            urlComponents.path = urlComponents.path.replacingOccurrences(of: HardCoded.dimensionHundred.get(), with: "/\(dimensionValue)x\(dimensionValue)bb.jpg")
            return urlComponents.string
        } else {
            return urlComponents.string
        }
    }
}

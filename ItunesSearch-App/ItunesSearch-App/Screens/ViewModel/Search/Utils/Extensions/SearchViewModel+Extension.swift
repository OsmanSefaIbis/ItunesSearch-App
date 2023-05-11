//
//  SearchViewModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 8.05.2023.
//

import Foundation

extension SearchViewModel{
   
    func changeImageURL(_ urlString: String, dimension dimensionValue: Int) -> String? {
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        if urlComponents.path.hasSuffix("/100x100bb.jpg") { // TODO: HardCoded?
            urlComponents.path = urlComponents.path.replacingOccurrences(of: "/100x100bb.jpg", with: "/\(dimensionValue)x\(dimensionValue)bb.jpg")
            return urlComponents.string
        } else {
            return urlComponents.string
        }
    }
}

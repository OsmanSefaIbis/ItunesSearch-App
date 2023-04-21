//
//  SearchModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension SearchModel{
    
    func composeUrl(_ term: String, _ media: Category, _ offset: Int) -> String {
        let termParam = (HardCoded.termParam.rawValue).appending(term)
        let mediaParam = (HardCoded.mediaParam.rawValue).appending(media.rawValue)
        let baseUrl = Api.url.scheme + Api.url.domain + Api.url.searchPath
        let urlCompose = baseUrl + termParam + mediaParam + Api.url.limit + Api.url.offsetLimit + String(offset)
        return urlCompose
    }
}

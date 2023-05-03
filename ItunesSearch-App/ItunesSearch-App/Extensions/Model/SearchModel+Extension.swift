//
//  SearchModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension SearchModel{
    
    func composeUrl(_ term: String, _ media: Category, _ offset: Int) -> String {
        
        let termParam = HardCoded.termParam.get().appending(term)
        let mediaParam = MediaParam.getWith(media)
        let baseUrl = Api.scheme.get() + Api.domain.get() + Api.searchPath.get()
        let urlCompose = baseUrl + termParam + mediaParam + Api.limit.get() + Api.offsetLimit.get() + String(offset)
        return urlCompose
    }
    
    func composeUrl(_ media: Category, _ offset: Int) -> String {
        
        let mediaParam = MediaParam.getWith(media)
        let baseUrl = Api.scheme.get() + Api.domain.get() + Api.searchPath.get()
        let urlCompose = baseUrl + mediaParam + Api.limit.get() + Api.offsetLimit.get() + String(offset)
        return urlCompose
    }
    
    func isValidJSON(_ jsonString: String) -> Bool {
        if let data = jsonString.data(using: .utf8) {
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: [])
                return true
            } catch {
                return false
            }
        }
        return false
    }
}

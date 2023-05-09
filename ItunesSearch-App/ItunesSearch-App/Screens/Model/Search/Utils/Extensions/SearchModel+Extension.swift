//
//  SearchModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension SearchModel{
    
    func composeUrl(_ term: String, _ media: MediaType, _ offset: Int) -> String {
        
        let termParam = HardCoded.termParam.get().appending(term)
        let mediaParam = MediaType.getParam(with: media)
        let baseUrl = Api.scheme.get() + Api.domain.get() + Api.searchPath.get()
        let urlCompose = baseUrl + termParam + mediaParam + Api.limit.get() + Api.offsetLimit.get() + String(offset)
        
        return urlCompose
    }
    
    func composeUrl(_ media: MediaType) -> String {
        
        let baseUrl = Api.scheme.get() + Api.domain.get()
        let countryParam = HardCoded.countryParam.get()
        let rssParam = HardCoded.rssParam.get()
        let mediaParam = media.getTop()
        let limitParam = HardCoded.limitParam.get()
        let jsonParam = HardCoded.jsonParam.get()
        let urlCompose = baseUrl + countryParam + rssParam + mediaParam + limitParam + jsonParam
        
        return urlCompose
    }
    func composeUrl(_ ids: [String]) -> String {
        
        let idParam = HardCoded.idParam.get().appending( ids.map { $0 }.joined(separator: ",") )
        let baseUrl = Api.scheme.get() + Api.domain.get() + Api.lookupPath.get()
        let urlCompose = baseUrl + idParam
        
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

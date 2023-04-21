//
//  DetailModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension DetailModel {
    
    func composeUrl(_ id: Int) -> String {
        let idParam = (HardCoded.idParam.rawValue).appending(String(id))
        let baseUrl = Api.url.scheme + Api.url.domain + Api.url.lookupPath
        let urlCompose = baseUrl + idParam
        return urlCompose
    }
}

//
//  DetailModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension DetailModel {
    
    func composeUrl(_ id: Int) -> String {
        
        let idParam = HardCoded.idParam.get().appending(String(id))
        let baseUrl = Api.scheme.get() + Api.domain.get() + Api.lookupPath.get()
        let urlCompose = baseUrl + idParam
        return urlCompose
    }
}

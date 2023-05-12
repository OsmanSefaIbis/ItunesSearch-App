//
//  DetailModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension DetailModel {
    
    func composeUrl(_ ids: [Int]) -> String {
        
        let idParam = HardCoded.idParam.get().appending( ids.map { String($0) }.joined(separator: ",") )
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

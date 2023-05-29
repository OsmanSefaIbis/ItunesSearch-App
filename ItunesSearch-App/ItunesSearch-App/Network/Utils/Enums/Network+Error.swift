//
//  Network+Error.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

enum NetworkError: Error {
    
    case invalidRequest
    case json(Error?)
    case url(Error?)
    case decode(Error?)
    case unresolved(Error?)
    case http(Int)
    
    var localizedDescription: String {
        switch self {
            case .invalidRequest:
                return "Error: Invalid Request"
            
            case .json(let error):
                if let error = error {
                    return "Error: Json Related \(error.localizedDescription)"
                } else {
                    return "Error: Json Related (Unknown)"
                }
            
            case .url(let error):
                if let error = error {
                    return "Error: Url Related \(error.localizedDescription)"
                } else {
                    return "Error: Url Related (Unknown)"
                }
            
            case .decode(let error):
                if let error = error {
                    return "Error: Decoding Related \(error.localizedDescription)"
                } else {
                    return "Error: Decoding Related (Unknown)"
                }
            
            case .http(let httpCode):
                return "Error: Http response code: \(httpCode)"
            
            case .unresolved(let error):
                if let error = error {
                    return "Error: Unresolved \(error.localizedDescription)"
                } else {
                    return "Error: Unresolved (Unknown)"
                }
        }
    }
}

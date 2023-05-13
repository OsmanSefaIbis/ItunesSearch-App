//
//  Network+Error.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

public enum NetworkError: Error {
    
    case invalidRequest
    case json(Error)
    case url(Error)
    case decode(Error)
    case unresolved(Error)
    
    var localizedDescription: String {
        switch self{
            case .invalidRequest: return "Error: Invalid Request"
            case .json(let error): return "Error: Json Related  \(error.localizedDescription)"
            case .url(let error): return "Error: Url Related \(error.localizedDescription)"
            case .decode(let error): return "Error: Decoding Related \(error.localizedDescription)"
            case .unresolved(let error): return "Error: Unresolved \(error.localizedDescription)"
        }
    }
}

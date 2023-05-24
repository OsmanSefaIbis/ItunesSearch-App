//
//  Endpoint.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

public typealias Parameters = [String : Any]

/// contract
public protocol Endpointable {
    
    var baseUrl: String { get }
    var searchPath: String { get }
    var lookupPath: String { get }
    var topMediaPath: String { get }
    var request: RequestType { get }
    var params: Parameters { get }
}

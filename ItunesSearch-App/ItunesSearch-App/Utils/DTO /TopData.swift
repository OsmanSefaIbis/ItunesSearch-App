//
//  TopData.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 4.05.2023.
//

import Foundation

struct TopResultData: Decodable {
    let feed: TopData?
}

struct TopData: Decodable {
    let entry: [TopDataIds]?
}

struct TopDataIds: Decodable {
    let id: ID?
}

struct ID: Decodable {
    let attributes: IDAttributes?
}

struct IDAttributes: Decodable {
    let imID: String?

    enum CodingKeys: String, CodingKey {
        case imID = "im:id"
    }
}




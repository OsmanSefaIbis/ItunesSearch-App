//
//  DetailData.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation

struct DetailResultData: Decodable {
    
    let resultCount: Int?
    let results: [DetailData]?
}

struct DetailData: Decodable {
    let wrapperType, kind: String?
    let collectionID, trackID: Int?
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionViewURL: String?
    let feedURL: String?
    let trackViewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice, collectionHDPrice: Int?
    let releaseDate: Date?
    let collectionExplicitness, trackExplicitness: String?
    let trackCount, trackTimeMillis: Int?
    let country, currency, primaryGenreName, contentAdvisoryRating: String?
    let artworkUrl600: String?
    let genreIDS, genres: [String]?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case collectionViewURL = "collectionViewUrl"
        case feedURL = "feedUrl"
        case trackViewURL = "trackViewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice
        case collectionHDPrice = "collectionHdPrice"
        case releaseDate, collectionExplicitness, trackExplicitness, trackCount, trackTimeMillis, country, currency, primaryGenreName, contentAdvisoryRating, artworkUrl600
        case genreIDS = "genreIds"
        case genres
    }
}


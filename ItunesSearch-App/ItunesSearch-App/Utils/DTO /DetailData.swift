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
        let trackID: Int?
        let artistName, collectionName, trackName: String?
        let trackViewURL: String?
        let previewURL: String?
        let artworkUrl100: String?
        let trackPrice: Double?
        let releaseDate: String?
        let trackTimeMillis: Int?
        let primaryGenreName: String?
        let longDescription: String?
        let genres: [String]?
        let description: String?
        let fileSizeBytes: Int?
        let averageUserRating: Double?
        let userRatingCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case wrapperType, kind
            case trackID = "trackId"
            case artistName, collectionName, trackName
            case trackViewURL = "trackViewUrl"
            case previewURL = "previewUrl"
            case artworkUrl100,trackPrice
            case releaseDate, trackTimeMillis, primaryGenreName, longDescription
            case genres, description
            case fileSizeBytes,averageUserRating, userRatingCount
        }
}

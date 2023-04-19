//
//  MusicData.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.04.2023.
//
import Foundation

struct SearchResultData: Decodable {
    
    let resultCount: Int?
    let results: [SearchData]?
}
struct SearchData: Decodable {
    let wrapperType: WrapperType?
    let kind: Kind?
    let trackID: Int?
    let artistName, collectionName, trackName: String?
    let artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let releaseDate: String?
    let trackTimeMillis: Int?
    let primaryGenreName: String?
    
    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case trackID = "trackId"
        case artistName, collectionName, trackName
        case artworkUrl100, collectionPrice, trackPrice, releaseDate, trackTimeMillis, primaryGenreName
    }
}

enum Kind: String, Codable {
    case featureMovie = "feature-movie"
    case podcast = "podcast"
    case song = "song"
    case ebook = "ebook"
}

enum WrapperType: String, Codable {
    case track = "track"
}


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
    let collectionID, trackID: Int?
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionArtistID: Int?
    let collectionArtistViewURL, collectionViewURL, trackViewURL: String?
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice, trackRentalPrice, collectionHDPrice: Double?
    let trackHDPrice, trackHDRentalPrice: Double?
    let releaseDate: Date?
    let collectionExplicitness, trackExplicitness: Explicitness?
    let trackCount, trackNumber, trackTimeMillis: Int?
    let country: Country?
    let currency: Currency?
    let primaryGenreName, contentAdvisoryRating, longDescription: String?
    let hasITunesExtras: Bool?
    let artistID: Int?
    let artistViewURL: String?
    let discCount, discNumber: Int?
    let isStreamable: Bool?
    let shortDescription, collectionArtistName, copyright, description: String?
    let feedURL: String?
    let artworkUrl600: String?
    let genreIDS, genres: [String]?
    let amgArtistID: Int?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case collectionArtistID = "collectionArtistId"
        case collectionArtistViewURL = "collectionArtistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, trackRentalPrice
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case trackHDRentalPrice = "trackHdRentalPrice"
        case releaseDate, collectionExplicitness, trackExplicitness, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, contentAdvisoryRating, longDescription, hasITunesExtras
        case artistID = "artistId"
        case artistViewURL = "artistViewUrl"
        case discCount, discNumber, isStreamable, shortDescription, collectionArtistName, copyright, description
        case feedURL = "feedUrl"
        case artworkUrl600
        case genreIDS = "genreIds"
        case genres
        case amgArtistID = "amgArtistId"
    }
}

enum Explicitness: String, Codable {
    case cleaned = "cleaned"
    case explicit = "explicit"
    case notExplicit = "notExplicit"
}

enum Country: String, Codable {
    case usa = "USA"
}

enum Currency: String, Codable {
    case usd = "USD"
}

enum Kind: String, Codable {
    case featureMovie = "feature-movie"
    case podcast = "podcast"
    case song = "song"
    case tvEpisode = "tv-episode"
}

enum WrapperType: String, Codable {
    case audiobook = "audiobook"
    case track = "track"
}

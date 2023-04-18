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
    let artistID, collectionID, trackID: Int?
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewURL, collectionViewURL, trackViewURL: String?
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let releaseDate: String?
    let collectionExplicitness, trackExplicitness: Explicitness?
    let discCount, discNumber, trackCount, trackNumber: Int?
    let trackTimeMillis: Int?
    let country: Country?
    let currency: Currency?
    let primaryGenreName: String?
    let contentAdvisoryRating: ContentAdvisoryRating?
    let isStreamable: Bool?
    let feedURL: String?
    let collectionHDPrice: Double?
    let artworkUrl600: String?
    let genreIDS, genres: [String]?
    let collectionArtistID: Int?
    let collectionArtistViewURL: String?
    let trackRentalPrice, trackHDPrice, trackHDRentalPrice: Double?
    let shortDescription, longDescription: String?
    let hasITunesExtras: Bool?
    let collectionArtistName, copyright, description: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, contentAdvisoryRating, isStreamable
        case feedURL = "feedUrl"
        case collectionHDPrice = "collectionHdPrice"
        case artworkUrl600
        case genreIDS = "genreIds"
        case genres
        case collectionArtistID = "collectionArtistId"
        case collectionArtistViewURL = "collectionArtistViewUrl"
        case trackRentalPrice
        case trackHDPrice = "trackHdPrice"
        case trackHDRentalPrice = "trackHdRentalPrice"
        case shortDescription, longDescription, hasITunesExtras, collectionArtistName, copyright, description
    }
}

enum Explicitness: String, Codable {
    case cleaned = "cleaned"
    case explicit = "explicit"
    case notExplicit = "notExplicit"
}

enum ContentAdvisoryRating: String, Codable {
    case clean = "Clean"
    case explicit = "Explicit"
    case pg = "PG"
    case r = "R"
    case tv14 = "TV-14"
    case tvG = "TV-G"
    case tvMa = "TV-MA"
    case tvPG = "TV-PG"
    case tvY = "TV-Y"
}

enum Country: String, Codable {
    case usa = "USA"
}

enum Currency: String, Codable {
    case usd = "USD"
}

enum Kind: String, Codable {
    case featureMovie = "feature-movie"
    case musicVideo = "music-video"
    case podcast = "podcast"
    case song = "song"
    case tvEpisode = "tv-episode"
    case ebook = "ebook"
}

enum WrapperType: String, Codable {
    case audiobook = "audiobook"
    case track = "track"
}


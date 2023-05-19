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
    let trackPrice: Double?
    let releaseDate: String?
    let trackTimeMillis: Int?
    let primaryGenreName: String?
    
    enum CodingKeys: String, CodingKey {
        
        case wrapperType, kind
        case trackID = "trackId"
        case artistName, collectionName, trackName
        case artworkUrl100, trackPrice, releaseDate, trackTimeMillis, primaryGenreName
    }
}

enum Kind: String, Codable {
    // all of them are needed , o.w causes decoding errors
    case featureMovie = "feature-movie"
    case podcast = "podcast"
    case song = "song"
    case ebook = "ebook"
    case musicVideo = "music-video"
    case tvShow = "tv-show"
    case shortFilm = "short-film"
    case software = "software"
    case audiobook = "audiobook"
    case trailer = "trailer"
    case interactiveBooklet = "interactive-booklet"
    case pdf = "pdf"
    case podcastEpisode = "podcast-episode"
}

enum WrapperType: String, Codable {
    // all of them are needed , o.w causes decoding errors
    case track = "track"
    case collection = "collection"
    case artist = "artist"
    case tvSeason = "tv-season"
    case movie = "movie"
    case audiobook = "audiobook"
    case ebook = "ebook"
}


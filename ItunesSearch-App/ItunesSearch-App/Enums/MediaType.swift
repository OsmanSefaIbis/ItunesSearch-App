//
//  MediaType.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 15.04.2023.
//

import Foundation

public enum MediaType: String {
    
    case movie, music, ebook, podcast
    
    func get() -> String {
        switch self{
            case .movie: return rawValue
            case .music: return rawValue
            case .ebook: return rawValue
            case .podcast: return rawValue
        }
    }
    func getView() -> String {
        switch self {
            case .movie: return "MovieDetailView"
            case .music: return "MusicDetailView"
            case .ebook: return "EbookDetailView"
            case .podcast: return "PodcastDetailView"
        }
    }
    func getKind() -> String {
        switch self {
            case .movie: return "feature-movie"
            case .music: return "song"
            case .ebook: return "ebook"
            case .podcast: return "podcast"
        }
    }
    func getTop() -> String {
        switch self {
            case .movie: return "topmovies/"
            case .music: return "topsongs/"
            case .ebook: return "topebooks/"
            case .podcast: return "toppodcasts/"
        }
    }
    func getTopV2() -> String {
        switch self {
            case .movie: return "/topmovies"
            case .music: return "/topsongs"
            case .ebook: return "/topebooks"
            case .podcast: return "/toppodcasts"
        }
    }
    static func getParam(with mediaType: MediaType) -> String{
        switch mediaType{
            case .movie: return "&media=movie"
            case .music: return "&media=music"
            case .ebook: return "&media=ebook"
            case .podcast: return "&media=podcast"
        }
    }
}

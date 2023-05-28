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
    func getStoryBoardId() -> String {
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
            case .movie: return "/topmovies"
            case .music: return "/topsongs"
            case .ebook: return "/topebooks"
            case .podcast: return "/toppodcasts"
        }
    }
}

//
//  CategoryViewNames.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

enum CategoryView: String{
    
    case movie, music, ebook, podcast
    
    func get() -> String{
        switch self{
            case .movie: return "MovieDetailView"
            case .music: return "MusicDetailView"
            case .ebook: return "EbookDetailView"
            case .podcast: return "PodcastDetailView"
        }
    }
}

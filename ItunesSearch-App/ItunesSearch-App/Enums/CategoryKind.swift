//
//  CategoryKind.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

enum CategoryKind: String {
    case movie, music, ebook, podcast
    
    func get() -> String {
        switch self{
            case .movie: return "feature-movie"
            case .music: return "song"
            case .ebook: return "ebook"
            case .podcast: return "podcast"
        }
    }
}

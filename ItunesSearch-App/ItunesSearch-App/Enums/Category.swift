//
//  category.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 15.04.2023.
//

import Foundation

enum Category: String{
    
    case movie, music, ebook, podcast
    
    func get() -> String{
        switch self{
            case .movie: return rawValue
            case .music: return rawValue
            case .ebook: return rawValue
            case .podcast: return rawValue
        }
    }
    func getTop() -> String{
        switch self{
        case .movie: return "topmovies/"
        case .music: return "topsongs/"
        case .ebook: return "topebooks/"
        case .podcast: return "toppodcasts/"
        }
    }
}

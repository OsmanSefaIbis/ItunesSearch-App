//
//  Api.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//
import Foundation

enum Api: String {
    case scheme, domain, searchPath, lookupPath, limit, offsetLimit
    
    func get() -> String{
        switch self{
            case .scheme: return "https://"
            case .domain: return "itunes.apple.com/"
            case .searchPath: return "search?"
            case .lookupPath: return "lookup?"
            case .limit: return "&limit=20"
            case .offsetLimit: return "&offset="
        }
    }
}

enum MediaParam: String {
    case movie, music, ebook, podcast
    
    func get() -> String{
        switch self{
            case .movie: return "&media=movie"
            case .music: return "&media=music"
            case .ebook: return "&media=ebook"
            case .podcast: return "&media=podcast"
        }
    }
    static func getWith(_ categoryValue: Category) -> String{
        switch categoryValue{
            case .movie: return "&media=movie"
            case .music: return "&media=music"
            case .ebook: return "&media=ebook"
            case .podcast: return "&media=podcast"
        }
    }
}


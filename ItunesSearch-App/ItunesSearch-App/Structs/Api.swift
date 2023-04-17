//
//  ApiRelated.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 14.04.2023.
//

import Foundation

struct Api{
    static let url = (scheme: "https://", domain: "itunes.apple.com/", path: "search?", limit: "&limit=\(requestLimit),", offsetLimit: "&offset=")
    static let media = (movie: "&media=movie", music: "&media=music", ebook: "&media=ebook", podcast: "&media=podcast")
}

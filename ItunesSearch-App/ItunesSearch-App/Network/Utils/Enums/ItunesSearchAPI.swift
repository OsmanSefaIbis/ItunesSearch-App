//
//  ItunesSearchApi.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

public enum ItunesSearchAPI {
    
    case search(input: String, media: MediaType, offset: Int)
    case lookup(idList: [Int])
    case topMedia(media: MediaType)
}



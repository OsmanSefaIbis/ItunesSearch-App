//
//  RequestQuery.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

struct RequestQuery{
    
    let search: SearchQuery?
    let idList: [Int]?
    let media: MediaType?
    
    init(search: SearchQuery? = nil, idList: [Int]? = nil, media: MediaType? = nil) {
        
        self.search = search
        self.idList = idList
        self.media = media
    }
}

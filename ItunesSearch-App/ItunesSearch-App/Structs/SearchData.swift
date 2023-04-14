//
//  MusicData.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.04.2023.
//
import Foundation

struct ApiData: Decodable {
    
    let resultCount: Int?
    let results: [SearchData]?
}
struct SearchData: Decodable {
    
    let artworkUrl100: String?
    let collectionName: String?
    let collectionPrice: Double?
    let releaseDate: String?
}

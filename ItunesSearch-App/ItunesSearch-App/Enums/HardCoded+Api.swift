//
//  Api.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//
import Foundation

enum Api: String {
    
    case scheme, domain, searchPath, lookupPath, termParam, limit, offsetLimit, rssParam, countryParam, jsonParam, limitParam
    
    // todayTODO: code duplication 
    func get() -> String {
        
        switch self {
            case .scheme: return "https://"
            case .domain: return "itunes.apple.com/"
            case .searchPath: return "search?"
            case .lookupPath: return "lookup?"
            case .termParam: return "term=" //
            case .limit: return "&limit=20" // todayTODO: static input, handle properly, make this dynamic
            case .limitParam: return "limit=100/"
            case .offsetLimit: return "&offset="
            case .rssParam: return "rss/"
            case .countryParam: return "us/"
            case .jsonParam: return "json"
        }
    }
    
    func getV2() -> String {
        
        switch self {
            case .scheme: return "https://"
            case .domain: return "itunes.apple.com"
            case .searchPath: return "/search"
            case .lookupPath: return "/lookup"
            case .termParam: return "term=" // delete
            case .limit: return "&limit=20" // delete
            case .limitParam: return "/limit=100" // delete
            case .offsetLimit: return "&offset=" // delete
            case .rssParam: return "/rss"
            case .countryParam: return "/us"
            case .jsonParam: return "/json"
        }
    }
}
 

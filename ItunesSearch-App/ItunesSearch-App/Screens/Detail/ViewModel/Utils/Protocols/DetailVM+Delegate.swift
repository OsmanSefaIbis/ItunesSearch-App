//
//  DetailViewModel+Delegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject{
    
    func storeItem(_ retrieved: [Detail])
    func cacheWrite(with retrieved: Detail, for query: CachingQuery)
    func passPage(_ page: DetailVC)
    func internetUnreachable(_ errorPrompt: String)
}

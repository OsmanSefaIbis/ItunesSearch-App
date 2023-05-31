//
//  DetailViewModel+Delegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject{
    
    func storeItem(_ retrieved: [Detail])
    func cacheWrite(for id: [Int], _ retrieved: [Detail], for cell: IndexPath)
    func passPage(_ page: DetailVC)
    func internetUnreachable(_ errorPrompt: String)
}

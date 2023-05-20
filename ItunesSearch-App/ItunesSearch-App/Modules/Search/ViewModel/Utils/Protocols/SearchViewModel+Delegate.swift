//
//  SearchViewModel+Delegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    
    func renderItems(_ retrieved: [SearchCellModel])
    func topItems(_ retrived: [Top])
    func internetUnreachable(_ errorPrompt: String)
}

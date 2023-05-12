//
//  SearchViewModel+Delegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation
// TODO: method naming
protocol SearchViewModelDelegate: AnyObject {
    
    func refreshItems(_ retrieved: [SearchCellModel])
    func topItems(_ retrived: [Top])
    func internetUnreachable(_ errorPrompt: String)
}

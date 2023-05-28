//
//  DetailViewModel+Delegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject{
    
    func storeItem(_ retrieved: [Detail])
    func passPage(_ page: DetailViewController)
    func internetUnreachable(_ errorPrompt: String)
}

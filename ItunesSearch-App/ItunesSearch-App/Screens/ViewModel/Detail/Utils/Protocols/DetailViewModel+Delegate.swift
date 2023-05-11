//
//  DetailViewModel+Delegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation
// TODO: naming
protocol DetailViewModelDelegate: AnyObject{
    
    func refreshItem(_ retrieved: [Detail])
    func internetUnreachable(_ errorPrompt: String)
}

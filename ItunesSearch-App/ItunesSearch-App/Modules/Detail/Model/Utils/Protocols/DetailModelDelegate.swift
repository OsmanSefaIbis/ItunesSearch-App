//
//  DetailModelDelegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 13.05.2023.
//

import Foundation

protocol DetailModelDelegate: AnyObject{
    
    func didFetchDetailData()
    func failedDataFetch()
}

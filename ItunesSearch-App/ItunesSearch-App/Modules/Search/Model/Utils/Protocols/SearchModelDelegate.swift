//
//  SearchModelDelegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 13.05.2023.
//

protocol SearchModelDelegate: AnyObject{
    
    func didFetchSearchData()
    func didFetchTopData()
    func failedDataFetch()
}

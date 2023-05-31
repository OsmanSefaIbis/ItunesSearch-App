//
//  SearchVC+DetailViewModelDelegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import Foundation

extension SearchVC: DetailViewModelDelegate {

    func storeItem(_ retrieved: [Detail]) {
        
        for each in retrieved{
            searchViewModel.setCacheDetails(key: each.id, value: each)
            
            provideImageColorPair(each.artworkUrl) { [weak self] pair in
                guard let self else { return }
                guard let pair else { return }
                self.searchViewModel.setCacheDetailImagesAndColor(key: each.id, value: pair)
            }
        }
    }
    
    func cacheWrite(for id: [Int], _ retrieved: [Detail]) {
        guard let id = id.first, let data = retrieved.first else { return }
        searchViewModel.setCacheDetails(key: id, value: data)
    }
    
    func passPage(_ page: DetailVC) {
        pushPageToNavigation(push: page)
    }
}

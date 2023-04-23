//
//  SearchViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 14.04.2023.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject{
    func refreshItems(_ retrieved: [SearchCellModel])
    func internetUnreachable(_ errorPrompt: String)
}

class SearchViewModel{
    private let model = SearchModel()
    weak var delegate: SearchViewModelDelegate?
    
    init(){
        model.delegate = self
    }
    func searchInvoked(_ searchTerm: String, _ mediaType: Category, _ offSetValue: Int) {
        model.fetchDataWithAF(input: searchTerm, media: mediaType, startFrom: offSetValue)
    }
}

extension SearchViewModel: SearchModelDelegate{
    func dataDidFetch(){
        let retrievedData: [SearchCellModel] = model.dataFetched.map{
            
            .init(
                id: $0.trackID ?? 0,
                artworkUrl: $0.artworkUrl100 ?? "",
                releaseDate: $0.releaseDate ?? "",
                name: $0.trackName ?? "",
                collectionName: $0.collectionName ?? "",
                collectionPrice: $0.collectionPrice ?? 0
            )
        }
        self.delegate?.refreshItems(retrievedData)
    }
    
    func dataCannotFetch() {
        delegate?.internetUnreachable("Check internet connectivity !")
    }
}

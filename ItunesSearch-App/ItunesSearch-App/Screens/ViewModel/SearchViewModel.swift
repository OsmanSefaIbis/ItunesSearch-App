//
//  SearchViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 14.04.2023.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    
    func refreshItems(_ retrieved: [SearchCellModel])
    func topItems(_ retrived: [Top])
    func internetUnreachable(_ errorPrompt: String)
}

class SearchViewModel {
    
    private let model = SearchModel()
    weak var delegate: SearchViewModelDelegate?
    
    init() {
        model.delegate = self
    }
    func topInvoked(_ mediaType: MediaType) {
        model.fetchTopPicks(with: mediaType)
    }
    func topWithIdsInvoked(_ topIds: [String]) {
        model.fetchByIds(for: topIds)
    }
    func searchInvoked(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int) {
        model.fetchDataForSearch(input: searchTerm, media: mediaType, startFrom: offSetValue)
    }
}

extension SearchViewModel: SearchModelDelegate {
    
    func dataDidFetch() {
        let retrievedData: [SearchCellModel] = model.dataFetched.map {
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
    func topDataDidFetch() {
        let retrievedIds: [Top] = model.topDataIdsFetched.map { .init( id: $0.id?.attributes?.imID ?? "" ) }
        self.delegate?.topItems(retrievedIds)
    }
    func dataDidNotFetch() {
        delegate?.internetUnreachable(HardCoded.offlinePrompt.get())
    }
}

//
//  SearchVM+SearchModelDelegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 29.05.2023.
//

import Foundation

extension SearchVM: SearchModelDelegate {
    
    func didFetchSearchData() {
        
        let retrievedData: [SearchCellModel] = model.searchResults.map {
            .init(
                id: $0.trackID ?? 0,
                artworkUrl: $0.artworkUrl100 ?? "",
                releaseDate: $0.releaseDate ?? "",
                name: $0.trackName ?? "",
                collectionName: $0.collectionName ?? "",
                trackPrice: $0.trackPrice ?? 0
            )
        }
        isNoResults_Flag = retrievedData.isEmpty ? true : false
        self.delegate?.renderItems(retrievedData)
    }
    
    func didFetchTopData() {
        let retrievedIds: [Top] = model.topResults.map { .init( id: $0.id?.attributes?.imID ?? "" ) }
        self.delegate?.topItems(retrievedIds)
    }
    
    func failedDataFetch() {
        delegate?.internetUnreachable(HardCoded.offlinePrompt.get())
    }
    
    func didCheckApiSendingLess(found verdict: Bool) {
        
        if verdict {
            lackingItems = model.lackingSearchResults.map {
                .init(
                    id: $0.trackID ?? 0,
                    artworkUrl: $0.artworkUrl100 ?? "",
                    releaseDate: $0.releaseDate ?? "",
                    name: $0.trackName ?? "",
                    collectionName: $0.collectionName ?? "",
                    trackPrice: $0.trackPrice ?? 0
                )
            }
        } else {
            lackingItems.removeAll()
        }
        isApiLackingData = verdict
    }
}

//
//  SearchModel.swift
//  ItunesSearch-App
//

import Foundation

final class SearchModel {
    
    weak var delegate: SearchModelDelegate?
    
    private(set) var searchResults: [SearchData] = []
    private(set) var lackingSearchResults: [SearchData] = []
    private(set) var topResults: [TopDataIds] = []
    
    private var network: NetworkAdapter { NetworkAdapter.shared }
    private var internet: InternetManager { InternetManager.shared }
    
    func fetchSearchResults(with query: SearchQuery) {
        
        if internet.isOnline() {
            network.fetchBySearch(by: query) { [weak self] response in
                guard let self else { return }
                switch response {
                    case .success(let data):
                        guard let results = data.results else { return }
                        self.searchResults = results
                        self.delegate?.didFetchSearchData()
                    case .failure(_):
                        self.delegate?.failedDataFetch()
                }
            }
        } else {
            delegate?.failedDataFetch()
        }
    }
    
    func fetchIdResults(for idList: [Int]) {
        
        if internet.isOnline() {
            network.fetchById(with: idList) { [weak self] response in
                guard let self else { return }
                switch response {
                    case .success(let data):
                        guard let results = data.results else { return }
                        self.searchResults = results
                        self.delegate?.didFetchSearchData()
                    case .failure(_):
                        self.delegate?.failedDataFetch()
                }
            }
        } else {
            delegate?.failedDataFetch()
        }
    }
    
    func fetchTopResults(with media: MediaType) {
        
        if internet.isOnline() {
            network.fetchTopPicks(by: media) { [weak self] response in
                guard let self else { return }
                switch response {
                    case .success(let data):
                        guard let results = data.feed?.entry else { return }
                        self.topResults = results
                        self.delegate?.didFetchTopData()
                    case .failure(_):
                        self.delegate?.failedDataFetch()
                }
            }
        } else {
            delegate?.failedDataFetch()
        }
    }
    
    func fetchLackingSearchResults(with query: SearchQuery, completion: (() -> Void)?) {
        
        if internet.isOnline() {
            ConstantsApp.changeLimit(with: 100)
            network.fetchBySearch(by: query) { [weak self] response in
                guard let self else { return }
                switch response {
                    case .success(let data):
                        ConstantsApp.changeLimit(with: 20)
                        guard let results = data.results else { return }
                        if results.count >= 20 {
                            self.lackingSearchResults = Array( results.prefix(20))
                            self.delegate?.didCheckApiSendingLess(found: true)
                        } else {
                            self.delegate?.didCheckApiSendingLess(found: false)
                        }
                    case .failure(_):
                        self.delegate?.failedDataFetch()
                }
                completion?()
            }
        } else {
            delegate?.failedDataFetch()
            completion?()
        }
    }
}

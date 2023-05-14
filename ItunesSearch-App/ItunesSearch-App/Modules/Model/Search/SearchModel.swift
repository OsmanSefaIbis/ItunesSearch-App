//
//  SearchModel.swift
//  ItunesSearch-App
//

import Foundation

final class SearchModel {
    
    weak var delegate: SearchModelDelegate?
    
    private(set) var searchResults: [SearchData] = []
    private(set) var topResults: [TopDataIds] = []
    
    private var network: NetworkAdapter { NetworkAdapter.shared }
    private var internet: InternetManager { InternetManager.shared }
    
    private let dtoSearch =  SearchResultData.self
    private let dtoTop = TopResultData.self
    
    func fetchSearchResults(with query: SearchQuery){
        
        if internet.isOnline() {
            network.fetchBySearch(by: query, dto: dtoSearch) { [weak self] response in
                guard let strongSelf = self else { return }
                switch response {
                    case .success(let data):
                        guard let results = data.results else { return }
                        strongSelf.searchResults = results
                        strongSelf.delegate?.didFetchSearchData()
                    case .failure(_):
                        self?.delegate?.failedDataFetch()
                }
            }
        } else {
            delegate?.failedDataFetch()
        }
    }
    
    func fetchIdResults(for idList: [Int]){
        
        if internet.isOnline() {
            network.fetchById(with: idList, dto: dtoSearch) { [weak self] response in
                guard let strongSelf = self else { return }
                switch response {
                    case .success(let data):
                        guard let results = data.results else { return }
                        strongSelf.searchResults = results
                        strongSelf.delegate?.didFetchSearchData()
                    case .failure(_):
                        self?.delegate?.failedDataFetch()
                }
            }
        } else {
            delegate?.failedDataFetch()
        }
    }
    
    func fetchTopResults(with media: MediaType){
        
        if internet.isOnline() {
            network.fetchTopPicks(by: media, dto: dtoTop) { [weak self] response in
                guard let strongSelf = self else { return }
                switch response {
                    case .success(let data):
                        guard let results = data.feed?.entry else { return }
                        strongSelf.topResults = results
                        strongSelf.delegate?.didFetchTopData()
                    case .failure(_):
                        self?.delegate?.failedDataFetch()
                }
            }
        } else {
            delegate?.failedDataFetch()
        }
    }
}

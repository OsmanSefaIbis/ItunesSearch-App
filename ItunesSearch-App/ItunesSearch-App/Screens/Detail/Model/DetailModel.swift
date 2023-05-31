//
//  DetailModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation

final class DetailModel{
    
    typealias dtoDetail = DetailResultData
    
    weak var delegate: DetailModelDelegate?

    private(set) var detailResults: [DetailData] = []
    private var network: NetworkAdapter { NetworkAdapter.shared }
    private var internet: InternetManager { InternetManager.shared }
    
    func fetchIdResults(for idList: [Int], flag isCacheMiss: Bool) {
        
        if internet.isOnline() {
            network.fetchById(with: idList, dtoType: dtoDetail.self) { [weak self] response in
                guard let self else { return }
                switch response {
                case .success(let data):
                    guard let results = data.results else { return }
                    self.detailResults = results
                    isCacheMiss ? self.delegate?.didFetchCacheMissData(with: idList) : self.delegate?.didFetchDetailData()
                case .failure(_):
                    self.delegate?.failedDataFetch()
                }
            }
        } else {
            delegate?.failedDataFetch()
        }
    }
}


//
//  DetailModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation

final class DetailModel{
    
    weak var delegate: DetailModelDelegate?

    private(set) var detailResults: [DetailData] = []
    
    private var network: NetworkAdapter { NetworkAdapter.shared }
    private var internet: InternetManager { InternetManager.shared }
    
    private let dtoDetail = DetailResultData.self
    
    func fetchIdResults(for idList: [Int]) {
        
        if internet.isOnline() {
            network.fetchById(with: idList, dto: dtoDetail) { [weak self] response in
                switch response {
                case .success(let data):
                    guard let results = data.results else { return }
                    self?.detailResults = results
                    self?.delegate?.didFetchDetailData()
                case .failure(_):
                    self?.delegate?.failedDataFetch()
                }
            }
        } else {
            delegate?.failedDataFetch()
        }
    }
}


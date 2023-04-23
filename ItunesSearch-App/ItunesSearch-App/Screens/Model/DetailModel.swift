//
//  DetailModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation

protocol DetailModelDelegate: AnyObject{
    func dataDidFetch()
    func dataCannotFetch()
}

class DetailModel{
    
    private(set) var dataFetched: [DetailData] = []
    weak var delegate: DetailModelDelegate?
    
    func fetchSingularData(for idValue: Int){
        
        if InternetManager.shared.isInternetActive() {
            let urlCompose = composeUrl(idValue)
            
            if let url = URL(string: urlCompose){
                var request: URLRequest = .init(url: url)
                request.httpMethod = HardCoded.getRequest.get()
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if error != nil { return }
                    if let data = data{
                        if ((self?.isValidJSON(String(data: data, encoding: .utf8)!)) != nil) {
                            do{
                                let DetailResultData = try JSONDecoder().decode(DetailResultData.self, from: data)
                                if let detailData = DetailResultData.results { self?.dataFetched = detailData }
                                self?.delegate?.dataDidFetch()
                            } catch { fatalError(HardCoded.fetchSingularDataError.get() + "\(error)" ) }
                        } else{
                            fatalError(HardCoded.invalidJSON.get())
                        }
                    }
                }
                task.resume()
            }
        }else {
            delegate?.dataCannotFetch()
        }
    }
}

//
//  DetailModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation
import Alamofire

protocol DetailModelDelegate: AnyObject{
    
    func dataDidFetch()
    func dataDidNotFetch()
}

class DetailModel{
    
    private(set) var dataFetched: [DetailData] = []
    weak var delegate: DetailModelDelegate?
    
    ///URLSession
    func fetchByIds(for idValues: [Int]){
        
        if InternetManager.shared.isInternetActive() {
            let urlCompose = composeUrl(idValues)
            
            if let url = URL(string: urlCompose){
                var request: URLRequest = .init(url: url)
                request.httpMethod = HardCoded.getRequest.get()
                
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if error != nil { return }
                    if let data = data {
                        
                        if ((self?.isValidJSON(String(data: data, encoding: .utf8)!)) != nil) {
                            do{
                                let detailResultData = try JSONDecoder().decode(DetailResultData.self, from: data)
                                if let detailData = detailResultData.results { self?.dataFetched = detailData }
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
            delegate?.dataDidNotFetch()
        }
    }
    ///Alamofire
    func fetchSingularDataWithAF(for idValues: [Int]) {

        if InternetManager.shared.isInternetActive() {
            let urlCompose = composeUrl(idValues)
            AF.request(urlCompose).responseDecodable(of: DetailResultData.self){ (res) in
                guard let response = res.value
                else{
                    self.delegate?.dataDidNotFetch()
                    return
                }
                self.dataFetched = response.results ?? []
                self.delegate?.dataDidFetch()
            }
        }else {
            delegate?.dataDidNotFetch()
        }
    }
}

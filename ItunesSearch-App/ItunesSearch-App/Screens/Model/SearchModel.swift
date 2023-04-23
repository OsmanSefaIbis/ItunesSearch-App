//
//  Search.swift
//  ItunesSearch-App
//
import Foundation
import UIKit
import Alamofire

protocol SearchModelDelegate: AnyObject{
    func dataDidFetch()
    func dataCannotFetch()
}

class SearchModel {
    
    private(set) var dataFetched: [SearchData] = []
    weak var delegate: SearchModelDelegate?
    
    /// URLSession
    func fetchDataWith(input termValue: String, media mediaType: Category, startFrom offset: Int) {
        
        if InternetManager.shared.isInternetActive() {
            let urlCompose = composeUrl(termValue, mediaType, offset)
            
            if let url = URL(string: urlCompose) {
                var request: URLRequest = .init(url: url)
                request.httpMethod = HardCoded.getRequest.get()
                
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if error != nil { return }
                    if let data = data {
                        
                        if ((self?.isValidJSON(String(data: data, encoding: .utf8)!)) != nil) {
                            do{
                                let SearchResultData = try JSONDecoder().decode(SearchResultData.self, from: data)
                                if let searchData = SearchResultData.results { self?.dataFetched = searchData }
                                self?.delegate?.dataDidFetch()
                            } catch { fatalError(HardCoded.fetchDataWithError.get() + "\(error)" ) }
                        } else {
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
    /// Alamofire
    func fetchDataWithAF(input termValue: String, media mediaType: Category, startFrom offset: Int) {
        
        if InternetManager.shared.isInternetActive() {
            let urlCompose = composeUrl(termValue, mediaType, offset)
            AF.request(urlCompose).responseDecodable(of: SearchResultData.self){ (res) in
                guard let response = res.value
                else{
                    self.delegate?.dataCannotFetch()
                    return
                }
                self.dataFetched = response.results ?? []
                self.delegate?.dataDidFetch()
            }
        }else {
            delegate?.dataCannotFetch()
        }
    }
    
}

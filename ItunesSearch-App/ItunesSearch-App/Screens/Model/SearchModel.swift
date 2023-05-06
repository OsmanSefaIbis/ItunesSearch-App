//
//  Search.swift
//  ItunesSearch-App
//
import Foundation
import UIKit
import Alamofire

protocol SearchModelDelegate: AnyObject{
    func dataDidFetch()
    func dataDidNotFetch()
    func topDataDidFetch()
    func topDataDidNotFetch()
}

class SearchModel {
    
    private(set) var dataFetched: [SearchData] = []
    private(set) var topDataIdsFetched: [TopDataIds] = []
    weak var delegate: SearchModelDelegate?
    
    /// URLSession
    func fetchDataWith(input termValue: String, media mediaType: MediaType, startFrom offset: Int) {
        
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
                                let searchResultData = try JSONDecoder().decode(SearchResultData.self, from: data)
                                if let searchData = searchResultData.results { self?.dataFetched = searchData }
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
            delegate?.dataDidNotFetch()
        }
    }
    
    func fetchByIds(for idValues: [String]){
        
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
                                let searchResultData = try JSONDecoder().decode(SearchResultData.self, from: data)
                                if let searchData = searchResultData.results { self?.dataFetched = searchData }
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
    
    func fetchTopTrendingByMediaType(media mediaType: MediaType){
        if InternetManager.shared.isInternetActive() {
            let urlCompose = composeUrl(mediaType)
            
            if let url = URL(string: urlCompose) {
                var request: URLRequest = .init(url: url)
                request.httpMethod = HardCoded.getRequest.get()
                
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if error != nil { return }
                    if let data = data {
                        
                        if ((self?.isValidJSON(String(data: data, encoding: .utf8)!)) != nil) {
                            do{
                                let topResultData = try JSONDecoder().decode(TopResultData.self, from: data)
                                if let topData = topResultData.feed {
                                    if let topDataIds = topData.entry{
                                        self?.topDataIdsFetched = topDataIds
                                    }
                                }
                                self?.delegate?.topDataDidFetch()
                            } catch { fatalError(HardCoded.fetchDataWithError.get() + "\(error)" ) }
                        } else {
                            fatalError(HardCoded.invalidJSON.get())
                        }
                    }
                }
                task.resume()
            }
        }else {
            delegate?.topDataDidNotFetch()
        }
    }
    
    /// Alamofire
    func fetchDataWithAF(input termValue: String, media mediaType: MediaType, startFrom offset: Int) {
        
        if InternetManager.shared.isInternetActive() {
            let urlCompose = composeUrl(termValue, mediaType, offset)
            AF.request(urlCompose).responseDecodable(of: SearchResultData.self){ (res) in
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

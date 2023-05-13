//
//  Search.swift
//  ItunesSearch-App
//
import Foundation
import UIKit
import Alamofire

// TODO: Add repository pattern, VM should do the web service calls, VM-M needs refactor
// TODO: Naming refactor is necessary, coherency is not attained
// TODO: Clean the code from repetition, detail and search have same service call, write a base class
// TODO: Consider Moya Apply it as an alternative for learning purposes

protocol SearchModelDelegate: AnyObject{
    
    func dataDidFetch()
    func dataDidNotFetch() // name these properly, let them have a file
    func topDataDidFetch()
}

class SearchModel {
    
    private(set) var dataFetched: [SearchData] = [] 
    private(set) var topDataIdsFetched: [TopDataIds] = []
    weak var delegate: SearchModelDelegate?
    
    private var network: NetworkAdapter { NetworkAdapter.shared }
    private var online: InternetManager { InternetManager.shared }
    
    // Refactored New Code
    
    func fetchSearchResults(input termValue: String, media mediaType: MediaType, startFrom offset: Int){
        
        let query: SearchQuery = .init(input: termValue, media: mediaType, offset: offset) // Migrate to view
        
        if online.isInternetActive(){
            network.fetchBySearch(by: query, dto: SearchResultData.self) { response in // add dto inside search query ?
                switch response {
                    case .success(let data):
                        self.dataFetched = data.results ?? []
                        self.delegate?.dataDidFetch()
                    case .failure(_):
                        self.delegate?.dataDidNotFetch()
                }
            }
        } else {
            delegate?.dataDidNotFetch()
        }
       
    }
    
    // Old Code
    /// URLSession
    func fetchDataForSearch(input termValue: String, media mediaType: MediaType, startFrom offset: Int) {
        
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
    func fetchTopPicks(with mediaType: MediaType){
        
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
            delegate?.dataDidNotFetch()
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

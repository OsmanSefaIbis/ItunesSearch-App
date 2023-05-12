//
//  NetworkAdapter.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

final class NetworkAdapter {
    
    static let shared = NetworkAdapter()
    
    private var session: URLSession { URLSession.shared }
    private var decoder: JSONDecoder { JSONDecoder() }
    
    private func composeRequest(endpoint: ItunesSearchAPI, request: RequestQuery) -> URLRequest? {
        
        func isNil(param: Any?) -> Bool{
            param == nil ? true : false
        }
        
        guard var components = URLComponents(string: endpoint.baseUrl) else { return nil }
        
        if !isNil(param: request.search){
            components.path = endpoint.searchPath
            components.queryItems = endpoint.params.map {
                URLQueryItem(name: $0.key , value: "\($0.value)")
            }
        }
        if !isNil(param: request.idList){
            components.path = endpoint.lookupPath
            components.queryItems = endpoint.params.map {
                URLQueryItem(name: $0.key , value: "\($0.value)")
            }
        }
        if !isNil(param: request.media){
            guard let media = request.media else { return nil }
            components.path = endpoint.topMediaPath.appending(media.getTop())
            components.queryItems = endpoint.params.map {
                URLQueryItem(name: $0.key , value: "\($0.value)")
            }

        }
        guard var url = components.url else {
            return nil
        }
        if !isNil(param: request.media){
            var urlString = url.absoluteString
            urlString.append(Api.jsonParam.getV2())
            guard let urlChange = URL(string: urlString) else { return nil }
            url = urlChange
        }
        
        return URLRequest(url: url)
    }
    
    func fetchBySearch < T: Decodable > (by query: SearchQuery, dto: T.Type, onCompletion: @escaping (Result< T,NetworkError >) -> Void ) {
        
        let requestQuery: RequestQuery = .init(search: query, idList: nil, media: nil)
        guard let request = composeRequest(endpoint: .search(input: query.input, media: query.media, offset: query.offset), request: requestQuery) else { return }
        
        let task = session.dataTask(with: request) { data, _, error in
            // TODO: fill
        }
        
        task.resume()
        
        
    }
    
    func fetchById < T: Decodable > ( with idList: [Int], dto: T.Type, onCompletion: @escaping (Result< T,NetworkError >) -> Void ) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: idList, media: nil)
        guard let request = composeRequest(endpoint: .lookup(idList: idList), request: requestQuery) else { return }
        
        let task = session.dataTask(with: request) { data, _, error in
            // TODO: fill
        }
        
        task.resume()
        
    }
    func fetchTopPicks < T: Decodable > (by media: MediaType, dto: T.Type, onCompletion: @escaping (Result< T,NetworkError >) -> Void ) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: nil, media: media)
        guard let request = composeRequest(endpoint: .topMedia(media: media), request: requestQuery) else { return }
        
        let task = session.dataTask(with: request) { data, _, error in
            // TODO: fill
        }
        
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func composeUrl(_ term: String, _ media: MediaType, _ offset: Int) -> String {
        
        let termParam = HardCoded.termParam.get().appending(term)
        let mediaParam = MediaType.getParam(with: media)
        let baseUrl = Api.scheme.get() + Api.domain.get() + Api.searchPath.get()
        let urlCompose = baseUrl + termParam + mediaParam + Api.limit.get() + Api.offsetLimit.get() + String(offset)
        
        return urlCompose
    }
    
}


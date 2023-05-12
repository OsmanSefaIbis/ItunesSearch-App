//
//  NetworkAdapter+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

///class extension
extension NetworkAdapter {
    
    func composeRequest(endpoint: ItunesSearchAPI, request: RequestQuery) -> URLRequest? {
        
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
}

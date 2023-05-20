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
            components.path = endpoint.topMediaPath
            let remainder = media.getTop().appending(Api.limitParam.get())
            components.path = components.path.appending(remainder)
        }
        guard var url = components.url else {
            return nil
        }
        if !isNil(param: request.media){
            var urlString = url.absoluteString
            urlString.append(Api.jsonParam.get())
            guard let urlChange = URL(string: urlString) else { return nil }
            url = urlChange
        }
        
        return URLRequest(url: url)
    }
    
    func isValidJSON(_ jsonString: String) -> Bool {
        if let data = jsonString.data(using: .utf8) {
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: [])
                return true
            } catch {
                return false
            }
        }
        return false
    }
}

//
//  NetworkAdapter+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

extension NetworkAdapter {
    
    func composeRequest(endpoint: ItunesSearchAPI, queryType: RequestQuery) -> URLRequest? {
        
        guard var components = URLComponents(string: endpoint.baseUrl) else { return nil }
        if let _ = queryType.search {
            components.path = endpoint.searchPath
            components.queryItems = endpoint.params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        else if let _ = queryType.idList {
            components.path = endpoint.lookupPath
            components.queryItems = endpoint.params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        else if let media = queryType.media {
            components.path = endpoint.topMediaPath
            let queryItems = media.getTop().appending(Api.limitParam.get())
            components.path.append(queryItems)
        }
        
        guard var url = components.url else { return nil }
        if let _ = queryType.media {
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

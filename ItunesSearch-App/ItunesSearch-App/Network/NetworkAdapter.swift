//
//  NetworkAdapter.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

final class NetworkAdapter {
    
    static let shared = NetworkAdapter()
    
    private let dtoSearch =  SearchResultData.self
    private let dtoDetail = DetailResultData.self
    private let dtoTop = TopResultData.self
    
    private var session: URLSession { URLSession.shared }
    
    func fetchBySearch(by query: SearchQuery, onCompletion: @escaping (Result <SearchResultData, NetworkError> ) -> Void) {
        
        let requestQuery: RequestQuery = .init(search: query, idList: nil, media: nil)
        guard let request = composeRequest(endpoint: .search(input: query.input, media: query.media, offset: query.offset ?? 0), request: requestQuery)
            else { onCompletion(.failure(.invalidRequest)) ; return }

        executeRequest(request: request, dto: dtoSearch, onCompletion: onCompletion)
    }
    
    func fetchById (with idList: [Int], onCompletion: @escaping (Result <SearchResultData, NetworkError> ) -> Void) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: idList, media: nil)
        guard let request = composeRequest(endpoint: .lookup(idList: idList), request: requestQuery) else { return }
            
        executeRequest(request: request, dto: dtoSearch, onCompletion: onCompletion)
    }
    
    func fetchById (with idList: [Int], onCompletion: @escaping (Result <DetailResultData, NetworkError> ) -> Void) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: idList, media: nil)
        guard let request = composeRequest(endpoint: .lookup(idList: idList), request: requestQuery) else { return }
            
        executeRequest(request: request, dto: dtoDetail, onCompletion: onCompletion)
    }
    
    func fetchTopPicks (by media: MediaType, onCompletion: @escaping (Result <TopResultData,NetworkError> ) -> Void) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: nil, media: media)
        guard let request = composeRequest(endpoint: .topMedia(media: media), request: requestQuery) else { return }
        
        executeRequest(request: request, dto: dtoTop, onCompletion: onCompletion)
    }
    
    private func executeRequest<T: Decodable>(
        request: URLRequest,
        dto: T.Type,
        decoder: JSONDecoder = JSONDecoder(),
        onCompletion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error as Error? {
                onCompletion(.failure(.url(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                onCompletion(.failure(.unresolved(error)))
                return
            }
            guard let data = data else {
                onCompletion(.failure(.unresolved(error)))
                return
            }
            let statusCode = httpResponse.statusCode
            if statusCode >= 200 && statusCode < 300 {
                do {
                    let jsonString = String(data: data, encoding: .utf8)
                    if let jsonString = jsonString, self.isValidJSON(jsonString) {
                        let result = try decoder.decode(dto, from: data)
                        onCompletion(.success(result))
                    } else {
                        onCompletion(.failure(.json(error)))
                    }
                } catch {
                    onCompletion(.failure(.decode(error)))
                }
            } else {
                onCompletion(.failure(.http(statusCode)))
            }
        }
        task.resume()
    }
}


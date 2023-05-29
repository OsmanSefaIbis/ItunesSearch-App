//
//  NetworkAdapter.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

final class NetworkAdapter {
    
    typealias dtoSearch = SearchResultData
    typealias dtoDetail = DetailResultData
    typealias dtoTop = TopResultData
    
    private var session: URLSession { URLSession.shared }
    static let shared = NetworkAdapter()

    func fetchBySearch(
        by query: SearchQuery,
        onCompletion: @escaping (Result <dtoSearch, NetworkError> ) -> Void
    ) {
        
        let type: RequestQuery = .init(search: query)
        guard let searchUrl = composeRequest(
            endpoint: .search(
                input: query.input,
                media: query.media,
                offset: query.offset ?? 0 ),
            queryType: type )
        else { onCompletion(.failure(.invalidRequest)) ; return }
        
        execute(request: searchUrl, dto: dtoSearch.self, onCompletion: onCompletion)
    }
    
    func fetchById<T: Decodable>(
        with idList: [Int],
        dtoType: T.Type,
        onCompletion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let type: RequestQuery = .init(idList: idList)
        guard let lookUpUrl = composeRequest(
            endpoint: .lookup(idList: idList),
            queryType: type)
        else { onCompletion(.failure(.invalidRequest)) ; return }
        
        execute(request: lookUpUrl, dto: dtoType, onCompletion: onCompletion)
    }

    func fetchTopPicks(
        by media: MediaType,
        onCompletion: @escaping (Result <dtoTop,NetworkError> ) -> Void
    ) {
        
        let requestQuery: RequestQuery = .init(media: media)
        guard let topPicksUrl = composeRequest(
            endpoint: .topMedia(media: media),
            queryType: requestQuery)
        else { onCompletion(.failure(.invalidRequest)) ; return }
        
        execute(request: topPicksUrl, dto: dtoTop.self, onCompletion: onCompletion)
    }
    
    private func execute<T: Decodable>(
        request: URLRequest,
        dto: T.Type,
        decoder: JSONDecoder = JSONDecoder(),
        onCompletion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        
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


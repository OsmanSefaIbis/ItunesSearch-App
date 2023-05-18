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
        guard let request = composeRequest(endpoint: .search(input: query.input, media: query.media, offset: query.offset), request: requestQuery)
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

        let task = session.dataTask(with: request) { [weak self] data, _, error in         // FIXME: Proper Error Handling
            guard let self else { return }
            do {
                guard let data = data, error == nil else{
                    throw error! // FIXME: Force Unwrap
                }
                guard let jsonString = String(data: data, encoding: .utf8) else { return } // ?
                if self.isValidJSON(jsonString) {
                    guard let result =  try? decoder.decode(dto, from: data) else {
                        onCompletion(.failure(.decode(error!))) // FIXME: Force Unwrap
                        return
                    }
                    onCompletion(.success(result))
                } else {
                    onCompletion(.failure(.json(error!))) // FIXME: Force Unwrap
                    return
                }
            } catch let error {
                switch error {
                case is URLError:
                    onCompletion(.failure(.url(error))) ; return
                default:
                    onCompletion(.failure(.unresolved(error))) ; return
                }
            }
        }
        task.resume()
    }

    
}


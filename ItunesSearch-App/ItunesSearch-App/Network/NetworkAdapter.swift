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
    
    func fetchBySearch < T: Decodable >(
        by query: SearchQuery,
        dto: T.Type,
        onCompletion: @escaping (Result <T,NetworkError> ) -> Void
    ) {
        let requestQuery: RequestQuery = .init(search: query, idList: nil, media: nil)
        
        guard let request = composeRequest(endpoint: .search(input: query.input, media: query.media, offset: query.offset), request: requestQuery)
            else { onCompletion(.failure(.invalidRequest)) ; return }

        executeRequest(request: request, dto: dto, onCompletion: onCompletion)
    }
    
    func fetchById < T: Decodable >(
        with idList: [Int],
        dto: T.Type,
        onCompletion: @escaping (Result <T,NetworkError> ) -> Void
    ) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: idList, media: nil)
        guard let request = composeRequest(endpoint: .lookup(idList: idList), request: requestQuery) else { return }
            
        executeRequest(request: request, dto: dto, onCompletion: onCompletion)
        
    }
    func fetchTopPicks < T: Decodable >(
        by media: MediaType,
        dto: T.Type,
        onCompletion: @escaping (Result <T,NetworkError> ) -> Void
    ) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: nil, media: media)
        guard let request = composeRequest(endpoint: .topMedia(media: media), request: requestQuery) else { return }
        
        executeRequest(request: request, dto: dto, onCompletion: onCompletion)
    }
    
    private func executeRequest<T: Decodable>(
        request: URLRequest,
        dto: T.Type,
        decoder: JSONDecoder = JSONDecoder(),
        onCompletion: @escaping (Result<T, NetworkError>) -> Void) {

        let task = session.dataTask(with: request) { [weak self] data, _, error in         // FIXME: Proper Error Handling
            do {
                guard let data = data, error == nil else{
                    throw error! // FIXME: Force Unwrap
                }
                if ((self?.isValidJSON(String(data: data, encoding: .utf8)!)) != nil){
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


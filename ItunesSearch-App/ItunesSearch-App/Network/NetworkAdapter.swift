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
    private var dummyError: NSError { NSError(domain: "", code: 0) }
    
    func fetchBySearch < T: Decodable >
        (by query: SearchQuery, dto: T.Type, decoder: JSONDecoder = JSONDecoder(), onCompletion: @escaping (Result <T,NetworkError> ) -> Void ) {
        
        let requestQuery: RequestQuery = .init(search: query, idList: nil, media: nil)
        
        guard let request = composeRequest(endpoint: .search(input: query.input, media: query.media, offset: query.offset), request: requestQuery)
            else { onCompletion(.failure(.invalidRequest)) ; return }
        
        let task = session.dataTask(with: request) { data, _, error in
            
            let dummyError = NSError(domain: "", code: 0)
            do {
                guard let data = data, error == nil else{
                    throw error ?? NetworkError.unresolved(error ?? dummyError)
                }
                guard let result =  try? decoder.decode(dto, from: data) else {
                    onCompletion(.failure(.decode(error ?? dummyError )))
                    return
                }
                onCompletion(.success(result))
                
            } catch let error {
                switch error {
                    case is DecodingError: fatalError(NetworkError.decode(error).localizedDescription) // todo this cannot be
                    case is URLError: fatalError(NetworkError.url(error).localizedDescription) // todo this cannot be
                default: fatalError(NetworkError.unresolved(error).localizedDescription)
                }
            }
            
        }
        
        task.resume()
        
        
    }
    
    func fetchById < T: Decodable >
        ( with idList: [Int], dto: T.Type, onCompletion: @escaping (Result <T,NetworkError> ) -> Void ) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: idList, media: nil)
        guard let request = composeRequest(endpoint: .lookup(idList: idList), request: requestQuery) else { return }
        
        let task = session.dataTask(with: request) { data, _, error in
            // TODO: fill
        }
        
        task.resume()
        
    }
    func fetchTopPicks < T: Decodable >
        (by media: MediaType, dto: T.Type, onCompletion: @escaping (Result <T,NetworkError> ) -> Void ) {
        
        let requestQuery: RequestQuery = .init(search: nil, idList: nil, media: media)
        guard let request = composeRequest(endpoint: .topMedia(media: media), request: requestQuery) else { return }
        
        let task = session.dataTask(with: request) { data, _, error in
            // TODO: fill
        }
        
        task.resume()
    }
    
}


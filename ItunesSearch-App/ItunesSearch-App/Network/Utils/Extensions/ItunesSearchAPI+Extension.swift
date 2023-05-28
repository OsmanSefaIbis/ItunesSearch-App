//
//  ItunesSearchAPI+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

extension ItunesSearchAPI: Endpointable {

    public var baseUrl: String { Api.scheme.get().appending(Api.domain.get()) }
    public var searchPath: String { Api.searchPath.get() }
    public var lookupPath: String { Api.lookupPath.get() }
    public var topMediaPath: String { Api.countryParam.get().appending(Api.rssParam.get()) }
    public var request: RequestType { .get }
    public var params: Parameters {
        
        switch self {
            case .search(let term, let media, let offset):
                var params = Parameters()
                params["term"] = term
                params["media"] = media.get()
                params["limit"] = ConstantsApp.requestLimit
                params["offset"] = offset
                
                return params
                
            case .lookup(let idList):
                var params = Parameters()
                params["id"] = idList.map { String($0) }.joined(separator: ",")
                return params
                
            case .topMedia(_):
                lazy var params = Parameters()
                return params
        }
    }
}

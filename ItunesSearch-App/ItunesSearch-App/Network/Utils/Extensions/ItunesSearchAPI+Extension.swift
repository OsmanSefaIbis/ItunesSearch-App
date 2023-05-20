//
//  ItunesSearchAPI+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 12.05.2023.
//

import Foundation

/// enum extension
extension ItunesSearchAPI: Endpointable {

    public var baseUrl: String { Api.scheme.getV2().appending(Api.domain.getV2()) }
    public var searchPath: String { Api.searchPath.getV2() }
    public var lookupPath: String { Api.lookupPath.getV2() }
    public var topMediaPath: String { Api.countryParam.getV2().appending(Api.rssParam.getV2()) }
    public var request: RequestType { .get }
    public var params: Parameters {
        
        switch self {
            case .search(let term, let media, let offset):
                var params = Parameters()
                params["term"] = term
                params["media"] = media.get()
                params["limit"] = 20
                params["offset"] = offset
                
                return params
                
            case .lookup(let idList):
                var params = Parameters()
                params["id"] = idList.map { String($0) }.joined(separator: ",")
                return params
                
            case .topMedia(_):
            var params = Parameters() // todayTODO: delete this part
                params["limit"] = 100
                return params
        }
    }
}

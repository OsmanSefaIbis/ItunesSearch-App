//
//  Search.swift
//  ItunesSearch-App
//



import Foundation

protocol SearchModelDelegate: AnyObject{
    func dataDidFetch()
}

class SearchModel {

    private(set) var dataFetched: [SearchData] = []
    weak var delegate: SearchModelDelegate?
    
    func fetchDataWith(input termValue: String, media mediaType: String, startFrom offset: Int) {

        let urlCompose = composeUrl(termValue, mediaType, offset)
        
        if let url = URL(string: urlCompose){
            var request: URLRequest = .init(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil{
                    return
                }
                if let data = data{
                    do{
                        let SearchResultData = try JSONDecoder().decode(SearchResultData.self, from: data)
                        if let searchData = SearchResultData.results{
                            self.dataFetched = searchData
                        }
                        self.delegate?.dataDidFetch()
                    } catch {
                        fatalError("Error occured with fetchDataWith() - Cause: Decoding Error --> \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    // TODO: Migrate this helper
    func composeUrl(_ term: String, _ media: String, _ offset: Int) -> String{
        
        let termParam = "term=".appending(term)
        let mediaParam = "&media=".appending(media)
        let baseUrl = Api.url.scheme + Api.url.domain + Api.url.searchPath
        let urlCompose = baseUrl + termParam + mediaParam + Api.url.limit + Api.url.offsetLimit + String(offset)
        
        return urlCompose
    }
}

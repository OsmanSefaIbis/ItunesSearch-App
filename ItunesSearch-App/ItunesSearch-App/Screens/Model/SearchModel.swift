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
    
    func fetchDataWith(input termValue: String, media mediaType: String) {

        let urlCompose = composeUrl(termValue, mediaType)
        
        if let url = URL(string: urlCompose){
            var request: URLRequest = .init(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil{
                    return
                }
                if let data = data{
                    do{
                        let apiData = try JSONDecoder().decode(ApiData.self, from: data)
                        if let searchData = apiData.results{
                            self.dataFetched = searchData
                        }
                        self.delegate?.dataDidFetch()
                    } catch {
                        print("Decoding Error")
                    }
                }
            }
            task.resume()
        }
    }
    
    // TODO: Migrate this helper
    func composeUrl(_ term: String, _ media: String) -> String{
        let termParam = "term=".appending(term)
        let mediaParam = "&media=".appending(media)
        let urlCompose = Api.url.scheme + Api.url.domain + Api.url.path + termParam + mediaParam
        return urlCompose
    }
}

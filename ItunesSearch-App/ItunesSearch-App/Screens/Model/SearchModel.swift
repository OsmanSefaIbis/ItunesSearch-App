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
    
    func fetchDataWith(input termValue: String, media mediaType: Category, startFrom offset: Int) {

        let urlCompose = composeUrl(termValue, mediaType, offset)
        
        if let url = URL(string: urlCompose){
            var request: URLRequest = .init(url: url)
            request.httpMethod = HardCoded.getRequest.rawValue
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

}

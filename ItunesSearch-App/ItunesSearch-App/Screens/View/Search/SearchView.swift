//
//  ViewController.swift
//  ItunesSearch-App
//

import UIKit

class SearchView: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        searchBar.delegate = self
    }
}
extension SearchView: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchInvoked(searchBar.text!, "movie")
    }
}
extension SearchView: SearchViewModelDelegate{
    func refreshItems(_ retrived: [SearchCellModel]) {
        DispatchQueue.main.async {
            self.nameLabel.text = retrived.first?.collectionName
            self.priceLabel.text = String(retrived.first!.collectionPrice)
            self.dateLabel.text = retrived.first?.releaseDate
        }
    }
}











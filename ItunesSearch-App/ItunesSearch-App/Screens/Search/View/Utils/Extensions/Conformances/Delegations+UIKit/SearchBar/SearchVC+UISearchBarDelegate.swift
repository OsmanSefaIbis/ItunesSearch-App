//
//  SearchVC+UISearchBarDelegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hapticFeedbackSoft()
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text?.replacingOccurrences(of: "\\s+", with: "+", options: .regularExpression) else { return }
        searchViewModel.searchBarSearchButtonClicked(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchViewModel.reset()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchViewModel.textDidChange(with: searchText)
    }
}

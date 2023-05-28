//
//  SearchVC+SearchViewModelDelegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit

extension SearchVC: SearchViewModelDelegate {

    func renderItems(_ retrieved: [SearchCellModel]) {
        setItems(retrieved)
        startPrefetchingDetails(for: searchViewModel.providesIds(retrieved))
    }
    
    func topItems(_ retrieved: [Top]) {
        invokeTopIds(retrieved)
    }
    
    func internetUnreachable(_ errorPrompt: String) {
        
        let alertController = UIAlertController(title: HardCoded.offLineAlertTitlePrompt.get(), message: errorPrompt, preferredStyle: .alert )
        let okAction = UIAlertAction(title: HardCoded.offLineActionTitlePrompt.get(), style: .default) { [weak self] (action:UIAlertAction!) in
            guard let self else { return }
            self.searchViewModel.reset()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

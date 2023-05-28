//
//  SearchVM+SearchVMContractHelper.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 29.05.2023.
//

import Foundation

/// Helps -> SearchVM+SearchVMContract
extension SearchVM {
    
    func resetCollections() {
        /// dealloc
        idsOfAllFetchedRecords.removeAll()
        cacheDetails.removeAll()
        cacheDetailImagesAndColors.removeAll()
    }
}

//
//  SearchVC+UICollectionViewDataSource.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit

extension SearchVC: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        
        searchViewModel.itemCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsCV.cell_ID, for: indexPath) as! SearchCell
        cell.configureCell(with: searchViewModel.cellForItem(at: indexPath), size: sizingValue )
        
        return cell
    }
}

//
//  SearchVC+UICollectionViewDelegateFlowLayout.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit

extension SearchVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        // INFO: SearchView+Pseudo.swift
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return ConstantsCV.cellSize }
        let totalWidth = collectionView.bounds.width
        let sectionInsets = flowLayout.sectionInset
        let cellSpacingMin = flowLayout.minimumInteritemSpacing
        let totalInsetSpace = (sectionInsets.left + sectionInsets.right)
        let totalCellSpacing = ((ConstantsCV.columnCount-1) * cellSpacingMin)
        let availableWidthForCells = (totalWidth - totalCellSpacing - totalInsetSpace)
        sizingValue = ( availableWidthForCells / CGFloat(ConstantsCV.columnCount) ) / 5
        let cellWidth = sizingValue * 5
        let cellHeight = sizingValue * 2
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        return cellSize
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return ConstantsCV.sectionInset }
        flowLayout.sectionInset = ConstantsCV.sectionInset
        
        return flowLayout.sectionInset
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return ConstantsCV.cellSpacing }
        flowLayout.minimumInteritemSpacing = ConstantsCV.cellSpacing
        
        return flowLayout.minimumInteritemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return ConstantsCV.cellSpacing }
        flowLayout.minimumLineSpacing = ConstantsCV.cellSpacing
        
        return flowLayout.minimumLineSpacing
    }
}

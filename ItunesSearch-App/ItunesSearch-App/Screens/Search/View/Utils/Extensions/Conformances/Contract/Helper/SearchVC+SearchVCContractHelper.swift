//
//  SearchViewContract+Helper.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit

/// Helps -> SearchVC+SearchViewContract
extension SearchVC {
    
    func assignPropsOfCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }

    func registersOfCollectionView() {

        let loadingReusableNib = UINib(nibName: HardCoded.loadingReusableName.get(), bundle: nil)
        let footerReusableNib = UINib(nibName: HardCoded.footerReusableName.get(), bundle: nil)
        let headerReusableNib = UINib(nibName: HardCoded.headerReusableName.get(), bundle: nil)
        collectionView?.register(.init(nibName: ConstantsCV.cell_ID, bundle: nil), forCellWithReuseIdentifier: ConstantsCV.cell_ID)
        collectionView?.register(loadingReusableNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: HardCoded.loadingReusableIdentifier.get())
        collectionView?.register(footerReusableNib,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                 withReuseIdentifier: HardCoded.footerReusableIdentifier.get())
        collectionView?.register(headerReusableNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HardCoded.headerReusableIdentifier.get())
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        hapticFeedbackSoft()
        guard let searchText = searchBar.text?.replacingOccurrences(of: "\\s+", with: "+", options: .regularExpression) else { return }
        let indexValue = sender.selectedSegmentIndex
        searchViewModel.segmentedControlValueChanged(to: indexValue, with: searchText)
    }
}


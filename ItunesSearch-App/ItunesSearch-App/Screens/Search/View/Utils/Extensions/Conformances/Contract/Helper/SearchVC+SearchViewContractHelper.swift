//
//  SearchViewContract+Helper.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit
import Kingfisher

/// Helps -> SearchVC+SearchViewContract
extension SearchVC {
    
    func assignPropsOfCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }

    func registersOfCollectionView() {

        let loadingReusableNib = UINib(nibName: HardCoded.loadingReusableName.get(), bundle: nil)
        let headerReusableNib = UINib(nibName: HardCoded.headerReusableName.get(), bundle: nil)
        collectionView?.register(.init(nibName: ConstantsCV.cell_ID, bundle: nil), forCellWithReuseIdentifier: ConstantsCV.cell_ID)
        collectionView?.register(loadingReusableNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: HardCoded.loadingReusableIdentifier.get())
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
    
    func provideImageColorPair(_ imageUrl: String, completion: @escaping (ImageColorPair?) -> Void) {
        
        guard let artworkUrl = URL(string: searchViewModel.modifyUrl(imageUrl, ConstantsCV.detailImageDimension)) else { completion(nil) ; return }
        KingfisherManager.shared.retrieveImage(with: artworkUrl) { result in
            switch result {
            case .success(let value):
                if let averagedColor = value.image.averageColor {
                    completion(.init(image: value.image, color: averagedColor))
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
}


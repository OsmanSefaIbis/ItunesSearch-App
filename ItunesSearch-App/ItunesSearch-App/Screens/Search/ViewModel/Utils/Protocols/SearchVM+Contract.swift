//
//  SearchViewModel+Interface.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation

protocol SearchVMContract {
    
    var itemCount: Int { get }
    /// assign & configure
    func viewDidLoad()
    /// fetch invocation
    func topInvoked()
    func topWithIdsInvoked(_ topIds: [Top])
    func searchInvoked(with query: SearchQuery)
    /// segmentedControl specific
    func segmentedControlValueChanged(to indexValue: Int, with searchText: String)
    /// collectionView specific
    func cellForItem(at indexPath: IndexPath) -> ColumnItem
    func didSelectItem(at indexPath: IndexPath)
    func willDisplay(at indexPath: IndexPath, with searchText: String)
    /// supplementaryView specific
    func referenceSizeForHeaderInSection(_ width: CGFloat) -> CGSize
    func referenceSizeForFooterInSection(_ width: CGFloat) -> CGSize
    func willDisplaySupplementaryFooterView()
    func willDisplaySupplementaryHeaderView()
    func didEndDisplayingSupplementaryView()
    /// searchBar specific
    func searchBarSearchButtonClicked(with searchText: String)
    func searchBarCancelButtonClicked()
    func textDidChange(with searchText: String)
    /// operations
    func setItems(_ items: [ColumnItem], completion: (() -> Void)?)
    func reset()
    func resetAndSearch(with query: SearchQuery)
    func resetAndInvokeTop()
    /// formatting helpers
    func modifyUrl(_ imageUrl: String, _ imageDimension: Int) -> String
    func providesIds(_ items: [ColumnItem]) -> [Int]
    /// data specific
    func setCacheDetails(key id: Int, value detail: Detail)
    func setCacheDetailImagesAndColor( key id: Int, value detail: ImageColorPair)
}

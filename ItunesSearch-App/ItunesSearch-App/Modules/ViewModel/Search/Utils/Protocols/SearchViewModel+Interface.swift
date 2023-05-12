//
//  SearchViewModel+Interface.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation
// TODO: order properly, order class
// TODO: Analyze this interface properly to make it as neat as possible
protocol SearchViewModelInterface {
    
    var view: SearchViewInterface? { get set }
    var itemCount: Int { get }

    func viewDidLoad()
    func segmentedControlValueChanged(to indexValue: Int, with searchText: String)
    func cellForItem(at indexPath: IndexPath) -> ColumnItem
    func didSelectItem(at indexPath: IndexPath)
    func willDisplay(at indexPath: IndexPath, with searchText: String)
    func referenceSizeForHeaderInSection(_ width: CGFloat) -> CGSize
    func referenceSizeForFooterInSection(_ width: CGFloat) -> CGSize
    func willDisplaySupplementaryFooterView()
    func willDisplaySupplementaryHeaderView()
    func didEndDisplayingSupplementaryView()
    func searchBarSearchButtonClicked(with searchText: String)
    func textDidChange(with searchText: String)
    
    func setItems(_ items: [ColumnItem])
    func reset()
    func resetAndSearch(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int?)
    func resetAndTrend(_ mediaType: MediaType)
    
    func modifyUrl(_ imageUrl: String, _ imageDimension: Int) -> String
    func providesIds(_ items: [ColumnItem]) -> [Int]
    func setCacheDetails(key id: Int, value detail: Detail)
    func setCacheDetailImagesAndColor( key id: Int, value detail: ImageColorPair)
}

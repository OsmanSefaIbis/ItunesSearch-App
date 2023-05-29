//
//  SearchView+Protocol.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import UIKit

protocol SearchVCContract: AnyObject {
    
    /// assignings
    func assignDelegates()
    /// configurations
    func configureCollectionView()
    func configureSegmentedControl()
    func configureSpinner()
    /// operations
    func initiateTopResults()
    func startPrefetchingDetails(for ids: [Int])
    func invokeTopIds( _ topIds: [Top])
    func resetAndSearch(with query: SearchQuery)
    func resetAndInvokeTop()
    func provideImageColorPair(_ imageUrl: String, completion: @escaping (ImageColorPair?) -> Void)
    /// data specific
    func setItems( _ items: [ColumnItem])
    func reset()
    /// UI specific
    func setReusableViewTitle()
    func setReusableViewTitle(with title: String)
    func stopReusableViewSpinner()
    func startReusableViewSpinner()
    func stopSpinner()
    func startSpinner()
    func reloadCollectionView()
    func initiateDetailCreation(with foundation: CompactDetail)
    func pushPageToNavigation(push thisPage: UIViewController)
    func dismissKeyBoard()
}

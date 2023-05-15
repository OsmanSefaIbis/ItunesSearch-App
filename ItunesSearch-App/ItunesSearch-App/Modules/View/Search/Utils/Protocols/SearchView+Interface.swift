//
//  SearchView+Protocol.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import UIKit
// TODO: order properly, order class
// TODO: Analyze this interface properly to make it as neat as possible
protocol SearchViewInterface: AnyObject {
    
    /// assignings
    func assignDelegates()
    /// configurations
    func configureCollectionView()
    func configureSegmentedControl()
    func configureActivityIndicator()
    /// operations
    func initiateTopResults()
    func startPrefetchingDetails(for ids: [Int])
    func invokeTopIds( _ topIds: [Top])
    func resetAndSearch(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int?)
    func resetAndTrend(_ mediaType: MediaType)
    /// data specific
    func setItems( _ items: [ColumnItem])
    func reset()
    /// UI specific
    func setReusableViewTitle(with title: String)
    func stopReusableViewActivityIndicator()
    func startReusableViewActivityIndicator()
    func stopActivityIndicator()
    func startActivityIndicator()
    func reloadCollectionView()
    func initiateDetailCreation(with foundation: CompactDetail)
    func pushPageToNavigation(push thisPage: UIViewController)
    func dismissKeyBoard()
}

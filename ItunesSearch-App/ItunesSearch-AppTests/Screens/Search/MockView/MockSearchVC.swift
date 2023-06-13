//
//  MockSearchVC.swift
//  ItunesSearch-AppTests
//
//  Created by Sefa İbiş on 12.06.2023.
//

@testable import ItunesSearch_App
import UIKit

final class MockSearchVC: SearchVCContract {
    
    /// invokation flags of the contract methods for viewDidLoad()
    var flag_assignDelegates = false
    var flag_configureCollectionView = false
    var flag_configureSegmentedControl = false
    var flag_configureSpinner = false
    var flag_initiateTopResults = false
    
    /// invokation counters to track the contract method viewDidLoad()
    var counter_assignDelegates = 0
    var counter_configureCollectionView = 0
    var counter_configureSegmentedControl = 0
    var counter_configureSpinner = 0
    var counter_initiateTopResults = 0
    
    
    
    func assignDelegates() {
        flag_assignDelegates = true
        counter_assignDelegates += 1
    }
    
    func configureCollectionView() {
        flag_configureCollectionView = true
        counter_configureCollectionView += 1
    }
    
    func configureSegmentedControl() {
        flag_configureSegmentedControl = true
        counter_configureSegmentedControl += 1
    }
    
    func configureSpinner() {
        flag_configureSpinner = true
        counter_configureSpinner += 1
    }
    
    func initiateTopResults() {
        flag_initiateTopResults = true
        counter_initiateTopResults += 1
    }
    
    func startPrefetchingDetails(for ids: [Int]) {
        
    }
    
    func invokeTopIds(_ topIds: [ItunesSearch_App.Top]) {
        
    }
    
    func resetAndSearch(with query: ItunesSearch_App.SearchQuery) {
        
    }
    
    func resetAndInvokeTop() {
        
    }
    
    func startCellSpinner(at indexPath: IndexPath) {
        
    }
    
    func stopCellSpinner(at indexPath: IndexPath) {
        
    }
    
    func handleCacheMiss(with query: ItunesSearch_App.CachingQuery) {
        
    }
    
    func provideImageColorPair(_ imageUrl: String, completion: @escaping (ItunesSearch_App.ImageColorPair?) -> Void) {
        
    }
    
    func setItems(_ items: [ItunesSearch_App.ColumnItem]) {
        
    }
    
    func reset() {
        
    }
    
    func setReusableHeaderViewTitle() {
        
    }
    
    func setReusableHeaderViewTitle(with title: String) {
        
    }
    
    func setReusableFooterViewTitle(with totalCount: Int) {
        
    }
    
    func stopReusableViewSpinner() {
        
    }
    
    func startReusableViewSpinner() {
        
    }
    
    func stopSpinner() {
        
    }
    
    func startSpinner() {
        
    }
    
    func reloadCollectionView() {
        
    }
    
    func initiateDetailCreation(with foundation: ItunesSearch_App.CompactDetail) {
        
    }
    
    func pushPageToNavigation(push thisPage: UIViewController) {
        
    }
    
    func dismissKeyBoard() {
        
    }
}

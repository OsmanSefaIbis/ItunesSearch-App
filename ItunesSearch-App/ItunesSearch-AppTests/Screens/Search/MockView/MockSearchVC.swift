//
//  MockSearchVC.swift
//  ItunesSearch-AppTests
//
//  Created by Sefa İbiş on 12.06.2023.
//

@testable import ItunesSearch_App
import UIKit

final class MockSearchVC: SearchVCContract {
    
    func assignDelegates() {
        
    }
    
    func configureCollectionView() {
        
    }
    
    func configureSegmentedControl() {
        
    }
    
    func configureSpinner() {
        
    }
    
    func initiateTopResults() {
        
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

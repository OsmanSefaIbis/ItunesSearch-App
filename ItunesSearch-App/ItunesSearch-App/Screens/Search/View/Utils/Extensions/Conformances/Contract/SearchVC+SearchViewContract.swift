//
//  SearchVC+SearchViewContract.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit
import Kingfisher

extension SearchVC: SearchViewContract {
    
    func assignDelegates() {
        searchViewModel.delegate = self
        detailViewModel.delegate = self
        searchBar.delegate = self
    }
    
    func configureCollectionView() {
        assignPropsOfCollectionView()
        registersOfCollectionView()
    }
    
    func configureSegmentedControl() {
        segmentedControl.addTarget(
            self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    func configureSpinner() {
        spinnerCollectionView.color = ConstantsApp.spinnerColor
    }
    
    func initiateTopResults() {
        startSpinner()
        searchViewModel.topInvoked()
    }
    
    func startPrefetchingDetails(for ids: [Int]) {
        detailViewModel.searchInvoked(withIds: ids)
    }
    
    func invokeTopIds( _ topIds: [Top]) {
        searchViewModel.topWithIdsInvoked(topIds)
    }
    
    func resetAndSearch(with query: SearchQuery) {
        searchViewModel.resetAndSearch(with: query)
    }
    
    func resetAndInvokeTop() {
        searchViewModel.resetAndInvokeTop()
    }
    
    func setItems( _ items: [SearchCellModel]) {
        searchViewModel.setItems(items, completion: {
            self.stopSpinner()
            self.reloadCollectionView()
        })
    }
    
    func reset() {
        searchViewModel.reset()
    }
    
    func setReusableViewTitle() {
        self.topPicksBar?.setTitleForNoResults()
    }
    
    func setReusableViewTitle(with title: String) {
        self.topPicksBar?.setTitleForTop(with: title)
    }
    
    func stopReusableViewSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pagingSpinner?.spinner.stopAnimating()
        }
    }
    
    func startReusableViewSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pagingSpinner?.spinner.startAnimating()
        }
    }
    
    func stopSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.spinnerCollectionView.stopAnimating()
        }
    }
    
    func startSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.spinnerCollectionView.startAnimating()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func initiateDetailCreation(with foundation: CompactDetail) {
        detailViewModel.view = storyboard?.instantiateViewController(withIdentifier: foundation.media.getStoryBoardId()) as! DetailViewController
        detailViewModel.view?.loadViewIfNeeded()
        detailViewModel.view?.viewModel = detailViewModel
        detailViewModel.assembleView(by: foundation)
    }
    
    func pushPageToNavigation(push thisPage: UIViewController) {
        self.navigationController?.pushViewController(thisPage, animated: true)
    }
    
    func dismissKeyBoard() {
        searchBar.resignFirstResponder()
    }
}

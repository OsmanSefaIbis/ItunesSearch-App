//
//  SearchVC+SearchViewContract.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit
import Kingfisher

extension SearchVC: SearchVCContract {

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
    
    func startCellSpinner(at indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let cell = self.collectionView.cellForItem(at: indexPath) as? SearchCell {
                cell.startSpinner()
            }
        }
    }
    
    func stopCellSpinner(at indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let cell = self.collectionView.cellForItem(at: indexPath) as? SearchCell {
                cell.stopSpinner()
            }
        }
    }
    
    func handleCacheMiss(with query: CachingQuery) {
        detailViewModel.cacheMissInvoked(for: query)
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
    
    func setItems( _ items: [SearchCellModel]) {
        searchViewModel.setItems(items, completion: {
            self.stopSpinner()
            self.reloadCollectionView()
        })
    }
    
    func reset() {
        searchViewModel.reset()
    }
    
    func setReusableHeaderViewTitle() {
        self.headerBar?.setTitleForNoResults()
    }
    
    func setReusableHeaderViewTitle(with title: String) {
        self.headerBar?.setTitleForTop(with: title)
    }
    
    func setReusableFooterViewTitle(with totalCount: Int){
        self.footerBar?.setTitle(for: totalCount)
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
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        detailViewModel.view = storyboard.instantiateViewController(withIdentifier: foundation.media.getStoryBoardId()) as! DetailVC
        detailViewModel.view?.loadViewIfNeeded()
        detailViewModel.view?.viewModel = detailViewModel
        detailViewModel.assembleView(by: foundation)
    }
    
    func pushPageToNavigation(push thisPage: UIViewController) {
        self.navigationController?.pushViewController(thisPage, animated: true)
    }
    
    func dismissKeyBoard() {
        DispatchQueue.main.async { [weak self] in
            self?.searchBar.resignFirstResponder()
        }
    }
}

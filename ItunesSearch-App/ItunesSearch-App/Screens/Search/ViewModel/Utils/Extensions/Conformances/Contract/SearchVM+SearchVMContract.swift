//
//  SearchVM+SearchViewModelContract.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 29.05.2023.
//

import Foundation

extension SearchVM: SearchVMContract {
    
    func viewDidLoad() {
        view?.assignDelegates()
        view?.configureCollectionView()
        view?.configureSegmentedControl()
        view?.configureSpinner()
        view?.initiateTopResults()
    }
    
    func topInvoked() {
        guard let mediaType = mediaType_State else { return }
        model.fetchTopResults(with: mediaType)
    }
    
    func topWithIdsInvoked(_ topIds: [Top]) {
        isTopPicksActive_Flag = true
        let holdsTopIds = topIds.compactMap { Int($0.id) }
        model.fetchIdResults(for: holdsTopIds)
    }
    
    func searchInvoked(with query: SearchQuery) {
        latestSearchedQuery = query
        model.fetchSearchResults(with: query)
    }
    
    func segmentedControlValueChanged(to indexValue: Int, with searchText: String) {
        
        switch indexValue {
            case 0: mediaType_State = MediaType.movie
                if searchText.count > 2 {
                    let query: SearchQuery = .init(input: searchText, media: MediaType.movie)
                    resetAndSearch(with: query)
                } else { resetAndInvokeTop() }

            case 1: mediaType_State = MediaType.music
                if searchText.count > 2 {
                    let query: SearchQuery = .init(input: searchText, media: MediaType.music)
                    resetAndSearch(with: query)
                } else { resetAndInvokeTop() }
            
            case 2: mediaType_State = MediaType.ebook
                if searchText.count > 2 {
                    let query: SearchQuery = .init(input: searchText, media: MediaType.ebook)
                    resetAndSearch(with: query)
                } else { resetAndInvokeTop() }
            
            case 3: mediaType_State = MediaType.podcast
                if searchText.count > 2 {
                    let query: SearchQuery = .init(input: searchText, media: MediaType.podcast)
                    resetAndSearch(with: query)
                } else { resetAndInvokeTop() }
            
        default: fatalError(HardCoded.segmentedControlError.get())
        }
    }
    
    func cellForItem(at indexPath: IndexPath) -> ColumnItem {
        items[indexPath.item]
    }

    func didSelectItem(at indexPath: IndexPath) {
        // PSEUDO: SearchVM+SearchVMContract+Pseudo2
        
        let id = items[indexPath.item].id
        guard let media = mediaType_State else { return }
        
        var cacheMiss = cacheDetails[id] == nil
        if cacheMiss {
            view?.startCellSpinner(at: indexPath)
            let query: CachingQuery = .init(id: id, cellIndexPath: indexPath)
            view?.handleCacheMiss(with: query)
        }
        guard let detailData = cacheDetails[id] else { return }

        cacheMiss = cacheDetailImagesAndColors[id] == nil
        if cacheMiss {
            view?.startCellSpinner(at: indexPath)
            let imageUrl = items[indexPath.item].artworkUrl
            view?.provideImageColorPair(imageUrl, completion: { [weak self] pair in
                guard let self else { return }
                self.cacheDetailImagesAndColors[id] = pair
                view?.stopCellSpinner(at: indexPath)
            })
        }
        guard let pair = cacheDetailImagesAndColors[id] else { return }
        
        let foundation: CompactDetail = .init(media: media, data: detailData, imageAndColor: pair)
        view?.initiateDetailCreation(with: foundation)
    }
    
    func willDisplay(at indexPath: IndexPath, with searchText: String) {
        
        if isLessThanPage_Flag || isTopPicksActive_Flag { return }
        let latestItemNumeric = items.count - 1
        if indexPath.item == latestItemNumeric {
            guard let mediaType = mediaType_State else { return }
            paginationOffSet += ConstantsApp.requestLimit
            isLoadingNextPage_Flag = true
            let query: SearchQuery = .init(input: searchText, media: mediaType, offset: paginationOffSet)
            searchInvoked(with: query)
        }
    }
    
    func referenceSizeForHeaderInSection(_ width: CGFloat) -> CGSize {
        if isSearchActive_Flag && !isNoResults_Flag{
            return CGSize.zero
        } else {
            return CGSize(width: width, height: ConstantsCV.headerHeight)
        }
    }
    
    func referenceSizeForFooterInSection(_ width: CGFloat) -> CGSize {
        if items.isEmpty{
            return CGSize.zero
        }
        if !isLoadingNextPage_Flag || isLessThanPage_Flag || isTopPicksActive_Flag {
            return CGSize(width: width, height: ConstantsCV.footerHeight)
        } else {
            return CGSize.zero
        }
    }
    
    func willDisplaySupplementaryFooterView() {
        if isLoadingNextPage_Flag { view?.startReusableViewSpinner() }
        if isLessThanPage_Flag || isTopPicksActive_Flag { view?.setReusableFooterViewTitle(with: itemCount)}
    }
    
    func willDisplaySupplementaryHeaderView() {
        if !isSearchActive_Flag {
            guard let mediaType = mediaType_State else { return }
            view?.setReusableHeaderViewTitle(with: mediaType.get().capitalized)
        }
        if isNoResults_Flag {
            view?.setReusableHeaderViewTitle()
        }
    }
    
    func didEndDisplayingSupplementaryView() {
        view?.stopReusableViewSpinner()
    }
    
    func searchBarSearchButtonClicked(with searchText: String) {
        
        guard let mediaType = mediaType_State else { return }
        
        if (0...2).contains(searchText.count) {
            if items.isEmpty {
                resetAndInvokeTop()
            }
        } else {
            if (1...20).contains(items.count) {
                view?.dismissKeyBoard()
            } else {
                paginationOffSet = 0
                let query: SearchQuery = .init(input: searchText, media: mediaType, offset: paginationOffSet)
                self.resetAndSearch(with: query)
            }
        }
    }
    
    func searchBarCancelButtonClicked() {
        isSearchActive_Flag = false
        resetAndInvokeTop()
    }
    
    func textDidChange(with searchText: String) {
        
        guard let mediaType = mediaType_State else { return }
        let search = searchText.replacingOccurrences(of: "\\s+", with: "+", options: .regularExpression)
        
        timeControl?.invalidate()
        timeControl = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { [weak self] (timer) in
            guard let self else { return }
            if (0...2).contains(search.count) {
                isSearchActive_Flag = false
                view?.stopSpinner()
            }
            if search.count > 2 {
                isSearchActive_Flag = true
                let query: SearchQuery = .init(input: search, media: mediaType, offset: paginationOffSet)
                resetAndSearch(with: query)
            }
        } )
        
    }
    
    func setItems(_ items: [ColumnItem], completion: (() -> Void)?) {
        // PSEUDO: SearchVM+SearchVMContract+Pseudo.swift
        
        isLessThanPage_Flag = items.count < ConstantsApp.requestLimit
        
        if isLessThanPage_Flag {
            let islastPage = self.items.count >= ConstantsApp.requestLimit
            if islastPage {
                var lastRecords: [ColumnItem] = []
            
                for each in items {
                    if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue }
                    else { lastRecords.append(each) }
                }
                self.items.append(contentsOf: lastRecords)
                idsOfAllFetchedRecords.removeAll()
                self.isLoadingNextPage_Flag = false
                completion?()
            } else {
                guard let query = latestSearchedQuery else { return }
                model.fetchLackingSearchResults(with: query) { [weak self] in
                    guard let self else { return }
                    if self.isApiLackingData_Flag {
                        self.isLessThanPage_Flag = false
                        self.items.append(contentsOf: self.lackingItems)
                        for each in self.lackingItems { idsOfAllFetchedRecords.insert(each.id) }
                        self.lackingItems.removeAll()
                    } else {
                        self.items = items
                    }
                    self.isLoadingNextPage_Flag = false
                    completion?()
                }
                return
            }
        } else {
            if paginationOffSet == 0 {
                for each in items { idsOfAllFetchedRecords.insert(each.id) }
                self.items = items
            } else {
                for each in items {
                    if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue }
                    else {
                        idsOfAllFetchedRecords.insert(each.id)
                        self.items.append(each)
                    }
                }
            }
        }
        isLoadingNextPage_Flag = false
        completion?()
    }

    func reset() {
        resetCollections()
        view?.stopSpinner()
        items.removeAll()
        view?.reloadCollectionView()
    }
    
    func resetAndSearch(with query: SearchQuery) {
        
        resetCollections()
        paginationOffSet = 0
        isLessThanPage_Flag = false
        isTopPicksActive_Flag = false
        
        if items.count > 0 {
            reset()
        }
        view?.startSpinner()
        if let _ = query.offset {
            searchInvoked(with: query)
        } else {
            let modifiedQuery: SearchQuery = .init(input: query.input, media: query.media, offset: paginationOffSet)
            searchInvoked(with: modifiedQuery)
        }
    }
    
    func resetAndInvokeTop() {
        reset()
        view?.startSpinner()
        topInvoked()
    }
    
    func modifyUrl(_ imageUrl: String, _ imageDimension: Int) -> String {
        guard let modifiedUrl = changeImageURL(imageUrl, dimension: imageDimension) else { return String()}
        return modifiedUrl
    }
    
    func providesIds(_ items: [ColumnItem]) -> [Int] {
        items.map{ $0.id }
    }
    
    func setCacheDetails(key id: Int, value detail: Detail) {
        cacheDetails[id] = detail
    }
    
    func setCacheDetailImagesAndColor( key id: Int, value pair: ImageColorPair) {
        cacheDetailImagesAndColors[id] = pair
    }
}

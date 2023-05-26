//
//  SearchViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 14.04.2023.
//

import Foundation

typealias ColumnItem = SearchCellModel

final class SearchViewModel {
    
    private let model = SearchModel()

    weak var view: SearchViewContract?
    weak var delegate: SearchViewModelDelegate?
    
    private var timeControl: Timer?
    private var items: [ColumnItem] = []
    private var idsOfAllFetchedRecords = Set<Int>()
    private var cacheDetails: [Int : Detail] = [:]
    private var cacheDetailImagesAndColors: [Int : ImageColorPair] = [:]

    private var paginationOffSet = 0
    private var mediaType_State: MediaType? = .movie
    private var lessThanPage_Flag = false
    private var isLoadingNextPage_Flag = false
    private var isSearchActive_Flag = false
    
    var itemCount: Int { get { items.count } }
    
    init() {
        model.delegate = self
    }
    func topInvoked() {
        guard let mediaType = mediaType_State else { return }
        model.fetchTopResults(with: mediaType)
    }
    func topWithIdsInvoked(_ topIds: [Top]) {
        let holdsTopIds = topIds.compactMap { Int($0.id) }
        model.fetchIdResults(for: holdsTopIds)
    }
    func searchInvoked(with query: SearchQuery) {
        model.fetchSearchResults(with: query)
    }
}

extension SearchViewModel: SearchModelDelegate {
    
    func didFetchSearchData() {
        let retrievedData: [SearchCellModel] = model.searchResults.map {  
            .init(
                id: $0.trackID ?? 0,
                artworkUrl: $0.artworkUrl100 ?? "",
                releaseDate: $0.releaseDate ?? "",
                name: $0.trackName ?? "",
                collectionName: $0.collectionName ?? "",
                trackPrice: $0.trackPrice ?? 0
            )
        }
        self.delegate?.renderItems(retrievedData)
    }
    
    func didFetchTopData() {
        let retrievedIds: [Top] = model.topResults.map { .init( id: $0.id?.attributes?.imID ?? "" ) }
        self.delegate?.topItems(retrievedIds)
    }
    
    func failedDataFetch() {
        delegate?.internetUnreachable(HardCoded.offlinePrompt.get())
    }
}

extension SearchViewModel: SearchViewModelContract {
    
    func viewDidLoad() {
        view?.assignDelegates()
        view?.configureCollectionView()
        view?.configureSegmentedControl()
        view?.configureSpinner()
        view?.initiateTopResults()
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
        
        let id = items[indexPath.item].id
        guard let media = mediaType_State else { return }
        guard let detailData = cacheDetails[id] else { return }
        /* FIXME: READ BELOW
            --> Kingfisher failure causes cache miss, so when the user selects,the detail page cannot be constructed
            --> * Partial fix, eventually routes to the detail page, not stable though,
            --> Time Profiler, also learn kingfisher details --> these might help
         
            --> Best case: Find the root cause why kingfisher is failing, another candidate is provideImageColorPair()
            --> Worst case: Use shimmer effect and when the data is fired reload
        */
        let cacheMiss = cacheDetailImagesAndColors[id] == nil
        if cacheMiss {
            let imageUrl = items[indexPath.item].artworkUrl
            view?.provideImageColorPair(imageUrl, completion: { [weak self] pair in
                guard let self else { return }
                self.cacheDetailImagesAndColors[id] = pair
            })
        }
        
        guard let pair = cacheDetailImagesAndColors[id] else { return }
        let foundation: CompactDetail = .init(media: media, data: detailData, imageAndColor: pair)
    
        view?.initiateDetailCreation(with: foundation)
    }
    
    func willDisplay(at indexPath: IndexPath, with searchText: String) {
        
        if lessThanPage_Flag { return }
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
        if self.isSearchActive_Flag {
            return CGSize.zero
        } else {
            return CGSize(width: width, height: ConstantsCV.headerHeight)
        }
    }
    
    func referenceSizeForFooterInSection(_ width: CGFloat) -> CGSize {
        if isLoadingNextPage_Flag {
            return CGSize.zero
        } else {
            return CGSize(width: width, height: ConstantsCV.footerHeight)
        }
    }
    
    func willDisplaySupplementaryFooterView() {
        if isLoadingNextPage_Flag { view?.startReusableViewSpinner() }
    }
    
    func willDisplaySupplementaryHeaderView() {
        if !isSearchActive_Flag {
            guard let mediaType = mediaType_State else { return }
            view?.setReusableViewTitle(with: mediaType.get().capitalized)
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
    
    func textDidChange(with searchText: String) {
        guard let mediaType = mediaType_State else { return }
        
        timeControl?.invalidate()
        timeControl = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [weak self] (timer) in
            guard let self else { return }
            if (0...2).contains(searchText.count) {
                isSearchActive_Flag = false
                view?.stopSpinner()
            }
            if searchText.count > 2 {
                isSearchActive_Flag = true
                let query: SearchQuery = .init(input: searchText, media: mediaType, offset: paginationOffSet)
                resetAndSearch(with: query)
            }
        } )
        
    }
    
    func setItems(_ items: [ColumnItem], completion: (() -> Void)?) {
        // INFO: SearchViewModel+Pseudo.swift
        if items.count != ConstantsApp.requestLimit { lessThanPage_Flag = true }
        
        if lessThanPage_Flag {
            if self.items.count >= ConstantsApp.requestLimit  {
                var lastRecords: [ColumnItem] = []
                
                for each in items {
                    if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue }
                    else { lastRecords.append(each) }
                }
                self.items.append(contentsOf: lastRecords)
                idsOfAllFetchedRecords.removeAll()
            } else {
                self.items = items
            }
        } else {
            if paginationOffSet == 0 {
                for each in items { idsOfAllFetchedRecords.insert(each.id) }
                self.items = items
            }else {
                for each in items { idsOfAllFetchedRecords.insert(each.id) }
                self.items.append(contentsOf: items)
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
        lessThanPage_Flag = false
        
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
    
    /// Contract Helper
    func resetCollections() {
        ///dealloc
        idsOfAllFetchedRecords.removeAll()
        cacheDetails.removeAll()
        cacheDetailImagesAndColors.removeAll()
    }
}

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

    weak var view: SearchViewInterface?
    weak var delegate: SearchViewModelDelegate?
    
    private var items: [ColumnItem] = []
    private var idsOfAllFetchedRecords = Set<Int>()
    private var cacheDetails: [Int : Detail] = [:]
    private var cacheDetailImagesAndColors: [Int : DetailImageAndColor] = [:]
    
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
        model.fetchTopPicks(with: mediaType)
    }
    func topWithIdsInvoked(_ topIds: [Top]) {
        let holdsTopIds = topIds.map { $0.id }
        model.fetchByIds(for: holdsTopIds)
    }
    func searchInvoked(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int) {
        model.fetchDataForSearch(input: searchTerm, media: mediaType, startFrom: offSetValue)
    }
}

extension SearchViewModel: SearchModelDelegate {
    
    func dataDidFetch() {
        let retrievedData: [SearchCellModel] = model.dataFetched.map {
            .init(
                id: $0.trackID ?? 0,
                artworkUrl: $0.artworkUrl100 ?? "",
                releaseDate: $0.releaseDate ?? "",
                name: $0.trackName ?? "",
                collectionName: $0.collectionName ?? "",
                collectionPrice: $0.collectionPrice ?? 0
            )
        }
        self.delegate?.refreshItems(retrievedData)
    }
    
    func topDataDidFetch() {
        let retrievedIds: [Top] = model.topDataIdsFetched.map { .init( id: $0.id?.attributes?.imID ?? "" ) }
        self.delegate?.topItems(retrievedIds)
    }
    
    func dataDidNotFetch() {
        delegate?.internetUnreachable(HardCoded.offlinePrompt.get())
    }
}

extension SearchViewModel: SearchViewModelInterface {
    
    func viewDidLoad() {
        view?.assignPropsOfSearchViewModel()
        view?.assignPropsOfDetailViewModel()
        view?.assignPropsOfSearchBar()
        view?.configureCollectionView()
        view?.configureSegmentedControl()
        view?.configureActivityIndicator()
        view?.initiateTopResults()
    }
    
    func segmentedControlValueChanged(to indexValue: Int, with searchText: String) {
        
        switch indexValue {
            case 0: mediaType_State = MediaType.movie
                if searchText.count > 2 { resetAndSearch(searchText, MediaType.movie, nil) }
                else { resetAndTrend(MediaType.movie) }
            
            case 1: mediaType_State = MediaType.music
                if searchText.count > 2 { resetAndSearch(searchText, MediaType.music, nil) }
                else { resetAndTrend(MediaType.music) }
            
            case 2: mediaType_State = MediaType.ebook
                if searchText.count > 2 { resetAndSearch(searchText, MediaType.ebook, nil) }
                else { resetAndTrend(MediaType.ebook) }
            
            case 3: mediaType_State = MediaType.podcast
                if searchText.count > 2 { resetAndSearch(searchText, MediaType.podcast, nil) }
                else { resetAndTrend(MediaType.podcast) }
        default: fatalError(HardCoded.segmentedControlError.get())
        }
    }
    
    func setItems(_ items: [ColumnItem]) { // INFO: SearchViewModel+Pseudo.swift

        if items.count != AppConstants.requestLimit { lessThanPage_Flag = true }
        
        if lessThanPage_Flag {
            if self.items.count >= AppConstants.requestLimit  {
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
        isLoadingNextPage_Flag = false // bug?
    }
    
    func cellForItem(at indexPath: IndexPath) -> ColumnItem {
        items[indexPath.item]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        guard let mediaType = mediaType_State else { return }
        var detailPage = view?.createDetailView(by: mediaType.getView())
        
        let id = items[indexPath.item].id
        guard let data = cacheDetails[id] else { return }
        guard let imageAndColor = cacheDetailImagesAndColors[id] else { return }
        let image = imageAndColor.image
        let color = imageAndColor.color
        guard var detailPage = detailPage else { return }
        
        view?.configureDetailView(id, data, &detailPage, image, color)
        view?.pushDetailPageToNavigation(detailPage)
    }
    
    func willDisplay(at indexPath: IndexPath, with searchText: String) {
        
        if lessThanPage_Flag { return }
        let latestItemNumeric = items.count - 1
        if indexPath.item == latestItemNumeric {
            guard let MediaType = mediaType_State else { return }
            paginationOffSet += AppConstants.requestLimit
            isLoadingNextPage_Flag = true
            searchInvoked(searchText, MediaType, paginationOffSet)
        }
    }
    
    func referenceSizeForHeaderInSection(_ width: CGFloat) -> CGSize {
        if self.isSearchActive_Flag {
            return CGSize.zero
        } else {
            return CGSize(width: width, height: 25)
        }
    }
    
    func referenceSizeForFooterInSection(_ width: CGFloat) -> CGSize {
        if self.isLoadingNextPage_Flag {
            return CGSize.zero
        } else {
            return CGSize(width: width, height: 40)
        }
    }
    
    func willDisplaySupplementaryFooterView() {
        if isLoadingNextPage_Flag { view?.startReusableViewActivityIndicator() }
    }
    
    func willDisplaySupplementaryHeaderView() {
        if !isSearchActive_Flag {
            guard let mediaType = mediaType_State else { return }
            view?.setReusableViewTitle(with: mediaType.get().capitalized)
        }
    }
    
    func didEndDisplayingSupplementaryView() {
        view?.stopReusableViewActivityIndicator()
    }
    
    func searchBarSearchButtonClicked(with searchText: String) {
        guard let mediaType = mediaType_State else { return }
        
        if (0...2).contains(searchText.count) {
            if items.isEmpty {
                resetAndTrend(mediaType)
            }
        } else {
            if (1...20).contains(items.count) {
                view?.dismissKeyBoard()
            } else {
                paginationOffSet = 0
                self.resetAndSearch(searchText, mediaType, paginationOffSet)
            }
        }
    }
    
    func textDidChange(with searchText: String) {
        guard let MediaType = mediaType_State else { return }
        
        if (0...2).contains(searchText.count) {
            isSearchActive_Flag = false
            view?.stopActivityIndicator()
        }
        if searchText.count > 2 {
            isSearchActive_Flag = true
            resetAndSearch(searchText, MediaType, paginationOffSet)
        }
    }
    
    func providesIds(_ items: [ColumnItem]) -> [Int] {
        items.map{ $0.id }
    }
    
    func setCacheDetails(key id: Int, value detail: Detail) {
        cacheDetails[id] = detail
    }
    
    func setCacheDetailImagesAndColor( key id: Int, value imageAndColor: DetailImageAndColor) {
        cacheDetailImagesAndColors[id] = imageAndColor
    }
    
    func modifyUrl(_ imageUrl: String, _ imageDimension: Int) -> String {
        guard let modifiedUrl = changeImageURL(imageUrl, dimension: imageDimension) else { return String()}
        return modifiedUrl
    }
    
    func reset() {
        resetCollections()
        view?.stopActivityIndicator()
        items.removeAll()
        view?.reloadCollectionView()
    }
    
    func resetAndSearch(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int?) {
        resetCollections()
        paginationOffSet = 0
        lessThanPage_Flag = false
        
        if items.count > 0 {
            reset()
        }
        view?.startActivityIndicator()
        if let offSet = offSetValue {
            searchInvoked(searchTerm, mediaType, offSet)
        } else {
            searchInvoked(searchTerm, mediaType, paginationOffSet)
        }
    }
    
    func resetAndTrend(_ mediaType: MediaType) {
        reset()
        view?.startActivityIndicator()
        topInvoked()
    }
    
    /// Interface Helper
    func resetCollections() {
        ///dealloc
        idsOfAllFetchedRecords.removeAll()
        cacheDetails.removeAll()
        cacheDetailImagesAndColors.removeAll()
    }
}

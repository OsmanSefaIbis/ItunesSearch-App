//
//  SearchViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 14.04.2023.
//

import Foundation

typealias RowItems = SearchCellModel

protocol SearchViewModelDelegate: AnyObject {
    
    func refreshItems(_ retrieved: [SearchCellModel])
    func topItems(_ retrived: [Top])
    func internetUnreachable(_ errorPrompt: String)
}

protocol SearchViewModelInterface {
    var view: SearchViewInterface? { get set }
    
    func viewDidLoad()
    func segmentedControlValueChanged(to indexValue: Int, with searchText: String)
    func reset()
    func resetAndSearch(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int?)
    func resetAndTrend(_ mediaType: MediaType)
    func setItems(_ items: [RowItems])
}

final class SearchViewModel {
    
    private let model = SearchModel()
    // protocol probs
    weak var view: SearchViewInterface?
    weak var delegate: SearchViewModelDelegate?
    
    // states
    private var lessThanPage_Flag = false
    private var isLoadingNextPage_Flag = false
    private var isSearchActive_Flag = false
    private var mediaType_State: MediaType? = .movie
    private var paginationOffSet = 0
    
    // partial data
    
    private var items: [RowItems] = []
    private var idsOfAllFetchedRecords = Set<Int>()
    private var cacheDetails: [Int : Detail] = [:]
    
    
    
    init() {
        model.delegate = self
    }
    func topInvoked(_ mediaType: MediaType) {
        model.fetchTopPicks(with: mediaType)
    }
    func topWithIdsInvoked(_ topIds: [String]) {
        model.fetchByIds(for: topIds)
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

extension SearchViewModel: SearchViewModelInterface{
    
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
    func setItems(_ items: [RowItems]) {
        // INFO: SearchViewModel+Pseudo.swift
        if items.count != AppConstants.requestLimit { lessThanPage_Flag = true }
        
        if lessThanPage_Flag {
            if self.items.count >= AppConstants.requestLimit  {
                var lastRecords: [RowItems] = []
                
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
        if let offSet = offSetValue{
            searchInvoked(searchTerm, mediaType, offSet)
        }else{
            searchInvoked(searchTerm, mediaType, paginationOffSet)
        }
    }
    func resetAndTrend(_ mediaType: MediaType) {
        reset()
        view?.startActivityIndicator()
        topInvoked(mediaType)
    }
    
    // helpers
    func resetCollections(){
        idsOfAllFetchedRecords.removeAll()
        cacheDetails.removeAll()
//        cacheDetailImagesAndColors.removeAll()
    }
}

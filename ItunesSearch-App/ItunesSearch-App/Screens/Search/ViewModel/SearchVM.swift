//
//  SearchViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 14.04.2023.
//

import Foundation

typealias ColumnItem = SearchCellModel

final class SearchVM {
    
    lazy var  model = SearchModel()

    weak var view: SearchVCContract?
    weak var delegate: SearchViewModelDelegate?
    
    var timeControl: Timer?
    var items: [ColumnItem] = []
    var idsOfAllFetchedRecords = Set<Int>()
    var cacheDetails: [Int : Detail] = [:]
    var cacheDetailImagesAndColors: [Int : ImageColorPair] = [:]
    var lackingItems: [ColumnItem] = []

    var paginationOffSet = 0
    var mediaType_State: MediaType? = .movie
    var lessThanPage_Flag = false
    var isLoadingNextPage_Flag = false
    var isSearchActive_Flag = false
    var isNoResults_Flag = false
    var latestSearchedQuery: SearchQuery?
    var isApiLackingData = false
    
    var itemCount: Int { get { items.count } }
    
    init() {
        model.delegate = self
    }
}

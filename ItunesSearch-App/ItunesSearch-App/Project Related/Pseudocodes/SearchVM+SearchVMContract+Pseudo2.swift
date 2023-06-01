//
//  SearchVM+SearchVMContract+Pseudo.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 1.06.2023.
//

/*----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                              • extension SearchVM: SearchVMContract                                                                 |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                                                                     |
| func didSelectItem(at indexPath: IndexPath) {         // Will not explain this code since its self explanatory                                      |
|                                                                                                                                                     |
|     let id = items[indexPath.item].id                                                                                                               |
|     guard let media = mediaType_State else { return }                                                                                               |
|                                                                                                                                                     |
|     var cacheMiss = cacheDetails[id] == nil                                                                                                         |
|     if cacheMiss {                                                                                                                                  |
|         view?.startCellSpinner(at: indexPath)                                                                                                       |
|         let query: CachingQuery = .init(id: id, cellIndexPath: indexPath)                                                                           |
|         view?.handleCacheMiss(with: query)                                                                                                          |
|     }                                                                                                                                               |
|     guard let detailData = cacheDetails[id] else { return }                                                                                         |
|                                                                                                                                                     |
|     cacheMiss = cacheDetailImagesAndColors[id] == nil                                                                                               |
|     if cacheMiss {                                                                                                                                  |
|         view?.startCellSpinner(at: indexPath)                                                                                                       |
|         let imageUrl = items[indexPath.item].artworkUrl                                                                                             |
|         view?.provideImageColorPair(imageUrl, completion: { [weak self] pair in                                                                     |
|             guard let self else { return }                                                                                                          |
|             self.cacheDetailImagesAndColors[id] = pair                                                                                              |
|             view?.stopCellSpinner(at: indexPath)                                                                                                    |
|         })                                                                                                                                          |
|     }                                                                                                                                               |
|                                                                                                                                                     |
|     guard let pair = cacheDetailImagesAndColors[id] else { return }                                                                                 |
|                                                                                                                                                     |
|     let foundation: CompactDetail = .init(media: media, data: detailData, imageAndColor: pair)                                                      |
|     view?.initiateDetailCreation(with: foundation)                                                                                                  |
| }                                                                                                                                                   |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                                                                     |
|        • NOTE: Cache miss happens when the network is slow or kingfisher is unable to download the image in time                                    |
|                                                                                                                                                     |
|        • NOTE: Kingfisher failure causes cache miss, so when the user selects the cell, the detail page could not be constructed                    |
|                                                                                                                                                     |
|        • NOTE: Partial fix applied, eventually routes to the detail page, added a spinner to the cell for UX purposes                               |
|                                                                                                                                                     |
|        • NOTE: Considering its scope, decided not to implement the most convenient solution.                                                        |
|                                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------*/



//
//  SearchViewModel+Pseudo.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 8.05.2023.
//

/*----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                              • extension SearchVM: SearchVMContract                                                                 |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                                                                     |
| func setItems(_ items: [ColumnItem], completion: (() -> Void)?) {                  /// self.items <- existing data  incoming data -> items          |
|                                                                                                                                                     |
|     isLessThanPage_Flag = items.count < ConstantsApp.requestLimit                  /// decision point (true == do not fetch more)                   |
|                                                                                                                                                     |
|     if isLessThanPage_Flag {                                                       /// -> less than a page                                          |
|         let islastPage = self.items.count >= ConstantsApp.requestLimit                                                                              |
|         if islastPage {                                                            /// • case: last page with less than request limit               |
|             var lastRecords: [ColumnItem] = []                                                                                                      |
|                                                                                                                                                     |
|             for each in items {                                                                                                                     |
|                 if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue }      /// skip                                             |
|                 else { lastRecords.append(each) }                                  /// track                                                        |
|             }                                                                                                                                       |
|             self.items.append(contentsOf: lastRecords)                             /// add track                                                    |
|             idsOfAllFetchedRecords.removeAll()                                     /// dealloc track                                                |
|             self.isLoadingNextPage_Flag = false                                                                                                     |
|             completion?()                                                                                                                           |
|         } else {                                                                   /// • case: a page less than the request limit (20)              |
|             guard let query = latestSearchedQuery else { return }                                                                                   |
|             model.fetchLackingSearchResults(with: query) { [weak self] in          /// makes a request call with limit 100 to compare               |
|                 guard let self else { return }                                     /// * this part of the code allows the pagination to continue    |
|                 if self.isApiLackingData_Flag {                                    /// -> enters upon the verdict of the comparison                 |
|                     self.isLessThanPage_Flag = false                               /// so actually it is not less than a page                       |
|                     self.items.append(contentsOf: self.lackingItems)               /// so adds the lacking items retrieved with request             |
|                     for each in self.lackingItems { idsOfAllFetchedRecords.insert(each.id) }                                                        |
|                     self.lackingItems.removeAll()                                                                                                   |
|                 } else {                                                           /// -> first page with less than request limit                   |
|                     self.items = items                                                                                                              |
|                 }                                                                                                                                   |
|                 self.isLoadingNextPage_Flag = false                                                                                                 |
|                 completion?()                                                                                                                       |
|             }                                                                                                                                       |
|             return                                                                                                                                  |
|         }                                                                                                                                           |
|     } else {                                                                       /// -> each page                                                 |
|         if paginationOffSet == 0 {                                                 /// • case: first full page                                      |
|             for each in items { idsOfAllFetchedRecords.insert(each.id) }                                                                            |
|             self.items = items                                                                                                                      |
|         } else {                                                                   /// • case: next page                                            |
|             for each in items {                                                                                                                     |
|                 if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue }      /// pass the duplicates                              |
|                 else {                                                                                                                              |
|                     idsOfAllFetchedRecords.insert(each.id)                                                                                          |
|                     self.items.append(each)                                                                                                         |
|                 }                                                                                                                                   |
|             }                                                                                                                                       |
|         }                                                                                                                                           |
|     }                                                                                                                                               |
|     isLoadingNextPage_Flag = false                                                                                                                  |
|     completion?()                                                                                                                                   |
| }                                                                                                                                                   |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                                                                     |
|        • NOTE: API does not support pagination via json, so offset and limit are used                                                               |
|                                                                                                                                                     |
|        • NOTE: API sends ambigous next pages that can overlap with the already existing data, so extract only required                              |
|                                                                                                                                                     |
|        • NOTE: API behavior is unpredictable, with limit 20 it might send less than 20 even though it has more than 20 records                      |
|                                                                                                                                                     |
|        • NOTE: API behaves this way, so handled with custom implementation, but still it is not the comprehensive solution, applied a partial fix   |
|                                                                                                                                                     |
|        • NOTE: Will not continue to fully implement the API response handling because it is out of the project scope. Bad API design :/             |
|                                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------*/


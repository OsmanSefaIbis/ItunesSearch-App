//
//  SearchViewModel+Pseudo.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 8.05.2023.
//

/*----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                              • extension SearchViewModel: SearchViewModelInterface                                                  |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                                                                     |
| func setItems( _ items: [ColumnItems]) {                                                   /// self.items <- existing data  incoming data -> items  |
|                                                                                                                                                     |
|     if items.count != ConstantsApp.requestLimit { lessThanPage_Flag = true }               /// decision point (true == do not fetch more)           |
|                                                                                                                                                     |
|     if lessThanPage_Flag {                                                                 /// less than a page                                     |
|         if self.items.count >= ConstantsApp.requestLimit  {                                /// case: last page with less than request limit         |
|             var lastRecords: [ColumnItems] = []                                                                                                     |
|                                                                                                                                                     |
|             for each in items {                                                                                                                     |
|                 if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue }  /// skip                                                 |
|                 else { lastRecords.append(each) }                                          /// track                                                |
|             }                                                                                                                                       |
|             self.items.append(contentsOf: lastRecords)                                     /// add track                                            |
|             idsOfAllFetchedRecords.removeAll()                                             /// dealloc track                                        |
|         } else {                                                                           /// case: first page with less than request limit        |
|             self.items = items                                                                                                                      |
|         }                                                                                                                                           |
|     } else {                                                                               /// each page                                            |
|         if paginationOffSet == 0 {                                                         /// first full page                                      |
|             for each in items { idsOfAllFetchedRecords.insert(each.id) }                                                                            |
|             self.items = items                                                                                                                      |
|         }else {                                                                            /// next page                                            |
|             for each in items { idsOfAllFetchedRecords.insert(each.id) }                                                                            |
|             self.items.append(contentsOf: items)                                                                                                    |
|         }                                                                                                                                           |
|     }                                                                                                                                               |
| }                                                                                                                                                   |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                                                                     |
|        • NOTE: API does not support pagination via json, offset and limit used                                                                      |
|                                                                                                                                                     |
|        • NOTE: API sends as the requestLimit, records can overlap at the end, so extract only the required                                          |
|                                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------*/


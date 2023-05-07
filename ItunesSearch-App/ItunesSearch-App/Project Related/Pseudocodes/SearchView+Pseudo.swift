//
//  SearchView+Pseudo.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 3.05.2023.
//


/*-----------------------------------------------------------------------------------------------
 • extension SearchView: UICollectionViewDelegateFlowLayout
-------------------------------------------------------------------------------------------------
    /*-- MODELS ----- MAX IOS --- WIDTH POINT -- HEIGHT POINT ---
    |    6s             15           375            667         |
    |    SE Gen1        15           320(MIN)       568         |
    |    SE Gen2        16           375            667         |
    |    13 Pro         16           390            844         |
    |    14 Pro         16           393            852         |
    |    14 Pro Max     16           430(MAX)       932         |
    -----------------------------------------------------------*/
-------------------------------------------------------------------------------------------------
    z = 2x + y + 2k     --> EQ1
-------------------------------------------------------------------------------------------------
    z --> totalAvailableWidth           --> known        --> varies between : 320~430
    x --> cellWidth                     --> unknown      --> calculate
    y --> minimumInterItemSpacing       --> can adjust   --> size: 10
    k --> left right section inset      --> can adjust   --> size: 5
-------------------------------------------------------------------------------------------------
    x = i + v = 5A      --> EQ2
-------------------------------------------------------------------------------------------------
    x      --> cellWidth                    --> 5A
    i      --> imageWidth ( 2A )            --> cellHeight == imageHeight == labelsHeight == 2A
    v      --> stackedLabelsWidth ( 3A )
    i/v    --> 2/3 aspect ratio of widths   --> FIND THE SWEET SPOT --> Critical
-------------------------------------------------------------------------------------------------
    z = 320 --> MIN CASE
    y = 10
    k = 5
    x = 320 - 10 - 10 = 300 / 2 = 150 = 5A --> A = 30 --> sizingValue
        Cell Width   = 5A = 150
        Cell Height  = 2A = 60
        Image Width  = 2A = 60
        Labels Width = 3A = 90
-------------------------------------------------------------------------------------------------
    z = 430 --> MAX CASE
    y = 10
    k = 5
    x = 430 - 10 - 10 = 410 / 2 = 205 = 5A --> A = 41 --> sizingValue
        Cell Width   = 5A = 205
        Cell Height  = 2A = 82
        Image Width  = 2A = 82
        Labels Width = 3A = 123
-------------------------------------------------------------------------------------------------
 Conclusion:  A = [ ( ( z - (( columnCount-1 * y ) - ( 2k )) )  / columnCount ) / 5 ]
-------------------------------------------------------------------------------------------------*/



/*-----------------------------------------------------------------------------------------------
 • class SearchView: UIViewController
-------------------------------------------------------------------------------------------------
 
 func setItems( _ items: [RowItems]) {
     /// NOTE: API does not support pagination via json, offset and limit used
     /// self.items <- existing data  incoming data -> items
 
     if items.count != AppConstants.requestLimit { lessThanPage_Flag = true } /// decision point (true == do not fetch more)

     if lessThanPage_Flag { /// less than a page
         if self.items.count >= AppConstants.requestLimit  { /// case: last page with less than request limit
             var lastRecords: [RowItems] = []
             /// NOTE: API sends as the requestLimit, records can overlap at the end, so extract only the required
             for each in items {
                 if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue } /// skip
                 else { lastRecords.append(each) } /// track
             }
             self.items.append(contentsOf: lastRecords) /// add track
             idsOfAllFetchedRecords.removeAll() /// dealloc track
         } else { /// case: first page with less than request limit
             self.items = items
         }
     } else { /// each page
         if paginationOffSet == 0 { /// first full page
             for each in items { idsOfAllFetchedRecords.insert(each.id) }
             self.items = items
         }else { /// next page
             for each in items { idsOfAllFetchedRecords.insert(each.id) }
             self.items.append(contentsOf: items)
         }
     }
     /// render
     DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(400)) {
         DispatchQueue.main.async {
             self.activityIndicatorOverall.stopAnimating()
             self.collectionView?.reloadData()
             self.isLoadingNextPage = false
         }
     }
 }
 
-------------------------------------------------------------------------------------------------*/

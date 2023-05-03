//
//  SearchView+Pseudo.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 3.05.2023.
//

// MARK: Below is migrated from extension SearchView: UICollectionViewDelegateFlowLayout

/*-----------------------------------------------------------------------------------------------
    /*-- MODELS ----- MAX IOS --- WIDTH POINT -- HEIGHT POINT ---
    |    6s             15           375            667         |
    |    SE Gen1        15           320(MIN)       568         |
    |    SE Gen2        16           375            667         |
    |    13 Pro         16           390            844         |
    |    14 Pro         16           393            852         |
    |    14 Pro Max     16           430(MAX)       932         |
    -----------------------------------------------------------*/
-------------------------------------------------------------------------------------------------
    z = 2x + 2y + 4k     --> EQ1
-------------------------------------------------------------------------------------------------
    z --> totalAvailableWidth      --> known        --> varies between : 320~430
    x --> cellWidth                --> unknown      --> calculate
    y --> minimumInterItemSpacing  --> can adjust   --> size: 10
    k --> left and right inset     --> can adjust   --> size: 5
-------------------------------------------------------------------------------------------------
    x = i + v = 5A      --> EQ2
-------------------------------------------------------------------------------------------------
    x      --> cellWidth                    --> 5A
    i      --> imageWidth ( 2A )            --> cellHeight == imageHeight == labelsHeight == 2A
    v      --> stackedLabelsWidth ( 3A )
    i/v    --> 2/3 aspect ratio of widths   --> UPDATE THIS --> FIND THE SWEET SPOT --> Critical
-------------------------------------------------------------------------------------------------
    z = 320 --> MIN CASE
    y = 10
    k = 5
    x = 320 - 20 - 20 = 280 / 2 = 140 = 5A --> A = 28 --> sizingValue
        Cell Width   = 5A = 140
        Cell Height  = 2A = 56
        Image Width  = 2A = 56
        Labels Width = 3A = 84
-------------------------------------------------------------------------------------------------
    z = 430 --> MAX CASE
    y = 10
    k = 5
    x = 430 - 20 - 20 = 390 / 2 = 195 = 5A --> A = 39 --> sizingValue
        Cell Width   = 5A = 195
        Cell Height  = 2A = 78
        Image Width  = 2A = 78
        Labels Width = 3A = 117
-------------------------------------------------------------------------------------------------
 Conclusion:  A = [ ( ( z - ( columnCount * y ) - ( columnCount * ( 2k )))/ columnCount) / 5 ]
-------------------------------------------------------------------------------------------------*/

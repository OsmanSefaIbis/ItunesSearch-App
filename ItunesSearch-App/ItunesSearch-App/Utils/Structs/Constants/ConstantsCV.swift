//
//  ConstantsCV.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 20.05.2023.
//

import UIKit

struct ConstantsCV {
    
    static let cell_ID: String = HardCoded.searchCell.get()
    static let columnCount: CGFloat = 2
    static let cellSpacing: CGFloat = 10.0
    static let sectionInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 0, right: 5)
    static let cellSize: CGSize = .init(width: 160, height: 80)
    static let detailImageDimension: Int = 600
    static let cellImageDimension = 200
    static let headerHeight: CGFloat = 25
    static let footerHeight: CGFloat = 40
}

// optional- featureTODO: make 'columnCount' into a feature, changeGrid(), constraint --> column of 2,3,4 only

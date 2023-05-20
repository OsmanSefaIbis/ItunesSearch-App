//
//  ConstantsCV.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 20.05.2023.
//

import UIKit

struct ConstantsCV {
    
    static let cell_ID: String = HardCoded.searchCell.get()
    static let columnCount: CGFloat = 2 // laterTODO: make this into a feature, changeGrid(), constraint --> column of 2,3,4 only
    static let cellSpacing: CGFloat = 10.0
    static let sectionInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 0, right: 5)
    static let sizingValue: CGFloat = 80.0
    static let cellSize: CGSize = .init(width: 160, height: 80)
    static let imageDimension: Int = 600
    static let dimensionPreference = 200
    static let headerHeight: CGFloat = 25
    static let footerHeight: CGFloat = 40
}

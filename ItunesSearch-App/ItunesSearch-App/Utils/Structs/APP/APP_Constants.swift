//
//  APP_Constants.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 26.04.2023.
//

import UIKit

struct AppConstants {
    
    static let activityIndicatorColor: UIColor = .systemPink
    static let requestLimit: Int = 20
    static let cellIdentifier: String = "SearchCell"
    static let accentColorName: String = "AccentColor"
    static let collectionViewColumn: CGFloat = 2 /// dynamically responds
    static let defaultMinimumCellSpacing: CGFloat = 10.0
    static let defaultSectionInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 0, right: 5)
    static let defaultSizingValue: CGFloat = 80.0
    static let defaultCellSize: CGSize = .init(width: 160, height: 80)
    static let imageDimensionForDetail: Int = 600
}

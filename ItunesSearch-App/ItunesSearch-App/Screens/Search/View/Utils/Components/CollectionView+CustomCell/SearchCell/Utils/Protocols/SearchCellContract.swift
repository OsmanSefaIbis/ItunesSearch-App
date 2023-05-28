//
//  SearchCellContract.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 24.05.2023.
//

import Foundation

protocol SearchCellContract {
    
    /// for reusability specific
    func prepareReusability()
    /// configure cell specific
    func configureCellLooks()
    func configureCell(with model: SearchCellModel, size constraint: CGFloat)
    /// constraint setters
    func setImageHeigth( _ height: CGFloat)
    func setImageWidth( _ width: CGFloat)
}

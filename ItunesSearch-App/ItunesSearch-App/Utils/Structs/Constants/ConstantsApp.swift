//
//  APP_Constants.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 26.04.2023.
//

import UIKit

struct ConstantsApp {
    
    static let spinnerColor: UIColor = .systemPink
    static var requestLimit: Int = 20
    static let accentColorName: String = HardCoded.accentColor.get()
    
    /// Added to handle API related limitation
    static func changeLimit(with value: Int){
        requestLimit = value
    }
}

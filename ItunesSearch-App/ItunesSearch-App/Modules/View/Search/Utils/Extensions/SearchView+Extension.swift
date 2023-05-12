//
//  SearchViewModel+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension SearchView{
    
    func hapticFeedbackHeavy() {
        hapticHeavy.prepare()
        hapticHeavy.impactOccurred(intensity: 1.0)
    }
    func hapticFeedbackSoft() {
        hapticSoft.prepare()
        hapticSoft.impactOccurred(intensity: 1.0)
    }
}

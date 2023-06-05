//
//  fkaojsdlkf.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 5.06.2023.
//

import UIKit

let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
let hapticSoft = UIImpactFeedbackGenerator(style: .soft)

extension SearchVC {
    
    func hapticFeedbackHeavy() {
        DispatchQueue.main.async {
            hapticHeavy.prepare()
            hapticHeavy.impactOccurred(intensity: 1.0)
        }
    }
    func hapticFeedbackSoft() {
        DispatchQueue.main.async {
            hapticSoft.prepare()
            hapticSoft.impactOccurred(intensity: 1.0)
        }
    }
}

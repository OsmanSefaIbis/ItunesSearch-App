//
//  DetailView+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import UIKit

extension DetailVC{
    
    func hapticFeedbackMedium() {
        hapticMedium.prepare()
        hapticMedium.impactOccurred(intensity: 1.0)
    }
}


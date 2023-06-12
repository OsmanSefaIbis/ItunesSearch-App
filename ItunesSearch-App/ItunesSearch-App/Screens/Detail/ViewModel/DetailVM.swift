//
//  DetailViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation

final class DetailVM{
    
    let model = DetailModel()
    
    weak var view: DetailVCContract?
    weak var delegate: DetailViewModelDelegate?
    
    var isAudioPlaying = false
    
    init(){
        model.delegate = self
    }
}

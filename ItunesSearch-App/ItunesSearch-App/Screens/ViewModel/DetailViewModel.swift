//
//  DetailViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject{
    //
}

class DetailViewModel{
    private let model = DetailModel()
    weak var delegate: DetailViewModelDelegate?
    
    init(){
        model.delegate = self
    }
}

extension DetailViewModel: DetailModelDelegate{
    func dataDidFetch(){

    }
}

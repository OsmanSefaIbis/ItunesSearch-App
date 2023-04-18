//
//  DetailView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import UIKit

class DetailView: UIViewController{
    
    //UIComponents
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailDescription: UILabel!
    
    private let viewModel = DetailViewModel()
    var id: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
    }
    
    func assignDelegates() {
        viewModel.delegate = self
    }
    
}

// MARK: Extensions

/************************   ViewModel  ************************/
extension DetailView: DetailViewModelDelegate{
    //
}

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
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailCreator: UILabel!
    @IBOutlet weak var detailCollectionName: UILabel!
    @IBOutlet weak var detailReleaseDate: UILabel!
    @IBOutlet weak var detailPrimaryGenre: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailLength: UILabel!
    @IBOutlet weak var detailSize: UILabel!
    @IBOutlet weak var detailRatingCount: UILabel!
    @IBOutlet weak var detailRating: UILabel!
    @IBOutlet weak var detailGenres: UILabel!
    @IBOutlet weak var detailPreviewButton: UIButton!
    @IBOutlet weak var detailViewButton: UIButton!
    
    private var item: Detail?
    var id = 0
    
    private let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        viewModel.didViewLoad(withId: id)
    }
    
    func assignDelegates() {
        viewModel.delegate = self
    }
    func configureItem(with item: Detail){
        
        self.detailImage.kf.setImage(with: URL.init(string: item.artworkUrl))
//        let category = item.kind
//        switch category{
//            // Mutuals
//            self.detailImage.kf.setImage(with: URL.init(string: item.artworkUrl))
//        // Diffs
//        case "feature-movie":
//
//        case "song":
//
//        case "ebook":
//
//        case "podcast":
//
//        }
        
    }
    
}

// MARK: Extensions

/************************   ViewModel  ************************/
extension DetailView: DetailViewModelDelegate{
    func refreshItem(_ retrieved: [Detail]) {
        configureItem(with: retrieved.first!)
    }
}

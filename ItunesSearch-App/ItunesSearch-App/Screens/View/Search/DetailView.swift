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
        let modifiedArtworkUrl = changeImageURL(item.artworkUrl)
        configureMutuals(item)
        let category = item.kind
        switch category{
            case "feature-movie":
                detailDescription.text = item.description
                detailCollectionName.text = item.collectionName
            case "song":
                detailLength.text = String(item.length)
            case "ebook":
                detailDescription.text = item.description
                detailSize.text = String(item.size)
                detailRatingCount.text = String(item.ratingCount)
                detailRating.text = String(item.rating)
            case "podcast":
                detailLength.text = String(item.length)
                detailCollectionName.text = item.collectionName
                detailGenres.text = item.genreList.joined(separator: ", ")
        default:
            return
        }
        func configureMutuals(_ item: Detail){
            detailImage.kf.setImage(with: URL.init(string: modifiedArtworkUrl ?? item.artworkUrl))
            detailName.text = item.name
            detailCreator.text = item.creator
            detailReleaseDate.text = item.releaseDate
            detailPrice.text = "$ ".appending(String(item.price))
            detailPrimaryGenre.text = item.genre
        }
        func changeImageURL(_ urlString: String) -> String? {
            guard var urlComponents = URLComponents(string: urlString) else {
                return nil
            }
            if urlComponents.path.hasSuffix("/100x100bb.jpg") {
                urlComponents.path = urlComponents.path.replacingOccurrences(of: "/100x100bb.jpg", with: "/600x600bb.jpg")
                return urlComponents.string
            } else {
                return urlComponents.string
            }
        }
    }
    // TODO: onPress
    @IBAction func viewButtonClicked(_ sender: Any) {
    }
    @IBAction func moviePreviewButtonClicked(_ sender: Any) {
    }
    @IBAction func musicPreviewButtonClicked(_ sender: Any) {
    }
}

// MARK: Extensions

/************************   ViewModel  ************************/
extension DetailView: DetailViewModelDelegate{
    func refreshItem(_ retrieved: [Detail]) {
        
        DispatchQueue.main.async {
            self.configureItem(with: retrieved.first!)
        }
    }
}

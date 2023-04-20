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
    @IBOutlet weak var detailDescription: UITextView!
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
    @IBOutlet weak var detailContent: UILabel!
    @IBOutlet weak var detailEpisodes: UILabel!
    
    
    
    
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
                detailDescription.text = item.longDescription
                detailCollectionName.text = item.collectionName
                detailPrimaryGenre.text = item.genre
            case "song":
                detailLength.text = formatTimeFromMillis(millis: item.length)
                detailPrimaryGenre.text = item.genre
            case "ebook":
            detailDescription.text = item.description.withoutHtmlEntities
                detailSize.text = convertBytesToGBorMB(item.size)
                detailRatingCount.text = item.ratingCount == 0 ?
                    "No Rating" : "# ".appending( String(item.ratingCount))
                detailRating.text = item.rating == 0.0 ? "No Rating" : String(item.rating).appending(" /5")
                detailGenres.text = item.genreList.joined(separator: ", ")
            case "podcast":
                detailLength.text = formatTimeFromMinutes(minutes: item.length)
                detailContent.text = item.advisory
                detailEpisodes.text = "# ".appending(String(item.episodeCount))
                detailCollectionName.text = item.collectionName
                detailGenres.text = item.genreList.joined(separator: ", ")
                detailPrimaryGenre.text = item.genre
        default:
            return
        }
        func configureMutuals(_ item: Detail){
            detailImage.kf.setImage(with: URL.init(string: modifiedArtworkUrl ?? item.artworkUrl))
            detailName.text = item.name
            detailCreator.text = item.creator
            detailReleaseDate.text = convertDate(for: item.releaseDate)
            detailPrice.text = item.price == 0 ? "Free" : "$ ".appending(String(item.price))
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

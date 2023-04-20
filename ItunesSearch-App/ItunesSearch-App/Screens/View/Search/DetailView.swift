//
//  DetailView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import UIKit
import WebKit
import AVFoundation
import AVKit

class DetailView: UIViewController{
    
    //UIComponents
    @IBOutlet private weak var detailImage: UIImageView!
    @IBOutlet private weak var detailDescription: UITextView!
    @IBOutlet private weak var detailName: UILabel!
    @IBOutlet private weak var detailCreator: UILabel!
    @IBOutlet private weak var detailCollectionName: UILabel!
    @IBOutlet private weak var detailReleaseDate: UILabel!
    @IBOutlet private weak var detailPrimaryGenre: UILabel!
    @IBOutlet private weak var detailPrice: UILabel!
    @IBOutlet private weak var detailLength: UILabel!
    @IBOutlet private weak var detailSize: UILabel!
    @IBOutlet private weak var detailRatingCount: UILabel!
    @IBOutlet private weak var detailRating: UILabel!
    @IBOutlet private weak var detailGenres: UILabel!
    @IBOutlet private weak var detailContent: UILabel!
    @IBOutlet private weak var detailEpisodes: UILabel!
    @IBOutlet private weak var detailTrackInfo: UILabel!
    
    private let webView = WKWebView()
    private var item: Detail?
    private var viewUrl: URL?
    private var previewUrl: URL?
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
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
        let modifiedArtworkUrl = changeImageURL(item.artworkUrl, withDimension: 600)
        configureMutuals(item)
        let category = item.kind
        switch category{
            case "feature-movie":
                detailDescription.text = item.longDescription
                detailCollectionName.text = item.collectionName
                detailPrimaryGenre.text = item.genre
                previewUrl = URL(string: item.previewUrl)
            case "song":
                detailLength.text = formatTimeFromMillis(millis: item.length)
                detailPrimaryGenre.text = item.genre
                detailCollectionName.text = item.collectionName
                detailTrackInfo.text = String(item.trackNumber).appending(" /").appending(String(item.albumNumber))
                previewUrl = URL(string: item.previewUrl)
            case "ebook":
            detailDescription.text = item.description.withoutHtmlEntities
                detailSize.text = convertBytesToGBorMB(item.size)
                detailGenres.text = item.genreList.joined(separator: ", ")
                detailRatingCount.text = item.ratingCount == 0 ? "No Rating" : "# ".appending( String(item.ratingCount))
                detailRating.text = item.rating == 0.0 ? "No Rating" : String(item.rating).appending(" /5")
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
            viewUrl = URL(string: item.viewUrl)
        }
    }
    // TODO: onPress
    @IBAction func viewButtonClicked(_ sender: Any) {
        let webViewVC = UIViewController()
        webViewVC.view = webView
        let request = URLRequest(url: viewUrl!)
        webView.load(request)
        let scrollView = webView.scrollView
        let topInset = navigationController?.navigationBar.frame.minY ?? 0
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    @IBAction func moviePreviewButtonClicked(_ sender: Any) {
        let player = AVPlayer(url: previewUrl!)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        present(playerViewController!, animated: true) {
            player.play()
        }
    }
    @IBAction func musicPreviewButtonClicked(_ sender: Any) {
        let playerItem = AVPlayerItem(url: previewUrl!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
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

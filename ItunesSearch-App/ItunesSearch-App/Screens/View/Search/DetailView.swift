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
    
    private let viewModel = DetailViewModel()
    private var item: Detail?
    var id = 0
    private let dimensionPreference = 600

    private let webView = WKWebView()
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
    private var viewUrl: URL?
    private var previewUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        viewModel.didViewLoad(withId: id)
    }
    
    func assignDelegates() {
        viewModel.delegate = self
    }
    func configureItem( with item: Detail){
        
        guard let modifiedArtworkUrl =
                changeImageURL(item.artworkUrl, withDimension: dimensionPreference) else { return }
        configureMutuals(item)
        
        func configureMutuals(_ item: Detail) {
            viewUrl = URL(string: item.viewUrl)
            detailName.text = item.name
            detailCreator.text = item.creator
            detailReleaseDate.text = convertDate( for: item.releaseDate)
            detailImage.kf.setImage(with: URL.init(string: modifiedArtworkUrl))
            
            detailPrice.text = (item.price == 0)
            ? HardCoded.free.rawValue : (HardCoded.dolar.rawValue)
                .appending(String(item.price))
        }
        
        switch item.kind{
            case CategoryKind.movie.rawValue: configureMovie()
            case CategoryKind.music.rawValue: configureMusic()
            case CategoryKind.ebook.rawValue: configureEbook()
            case CategoryKind.podcast.rawValue: configurePodcast()
        default:
            return
        }
        
        func configureMovie() {
            previewUrl = URL(string: item.previewUrl)
            detailPrimaryGenre.text = item.genre
            detailDescription.text = item.longDescription
            detailCollectionName.text = item.collectionName
        }
        func configureMusic() {
            previewUrl = URL(string: item.previewUrl)
            detailPrimaryGenre.text = item.genre
            detailCollectionName.text = item.collectionName
            detailLength.text = formatTimeFromMillis(millis: item.length)
            
            detailTrackInfo.text = String(item.trackNumber)
                .appending(HardCoded.trackSeperator.rawValue)
                .appending(String(item.albumNumber))
        }
        func configureEbook() {
            detailSize.text = convertBytesToGBorMB(item.size)
            detailDescription.text = item.description.withoutHtmlEntities
            detailGenres.text = item.genreList.joined(separator: HardCoded.seperator.rawValue)
            
            detailRatingCount.text = (item.ratingCount == 0)
                ? HardCoded.noRating.rawValue : (HardCoded.numberSign.rawValue)
                    .appending( String(item.ratingCount))
            detailRating.text = (item.rating == 0.0)
                ? HardCoded.noRating.rawValue : String(item.rating)
                    .appending(HardCoded.ratingScale.rawValue)
        }
        func configurePodcast() {
            detailContent.text = item.advisory
            detailPrimaryGenre.text = item.genre
            detailCollectionName.text = item.collectionName
            detailLength.text = formatTimeFromMinutes(minutes: item.length)
            detailGenres.text = item.genreList.joined(separator: HardCoded.seperator.rawValue)
            detailEpisodes.text = (HardCoded.numberSign.rawValue)
                .appending(String(item.episodeCount))
        }
    }
    
    /* Button Actions */
    
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
        present(playerViewController!, animated: true) { player.play() }
    }
    @IBAction func musicPreviewButtonClicked(_ sender: Any) {
        
        let playerItem = AVPlayerItem(url: previewUrl!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}

// MARK: Extensions

/* ViewModel Delegate */
extension DetailView: DetailViewModelDelegate{
    func refreshItem(_ retrieved: [Detail]) {
        DispatchQueue.main.async {
            self.configureItem(with: retrieved.first!)
        }
    }
}

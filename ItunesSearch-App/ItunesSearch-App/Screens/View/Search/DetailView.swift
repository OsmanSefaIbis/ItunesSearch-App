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
import Kingfisher

class DetailView: UIViewController{
    
    @IBOutlet private weak var detailContainerView: UIView!
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private weak var detailImageContainerView: UIView!
    @IBOutlet private weak var detailFieldsView: UIView!
    @IBOutlet private weak var detailDescriptionView: UIView!
    @IBOutlet private weak var detailButtonsView: UIView!
    @IBOutlet private weak var detailDescriptionTextView: UITextView!
    /// above is added for colorization
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
    
    private var item: Detail?
    var id = 0

    private let webView = WKWebView()
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
    private var viewUrl: URL?
    private var previewUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureItem( with item: Detail, image artworkImage: UIImage, color averageColor: UIColor){
        
        //let textColor: UIColor = isColorDark(averageColor) ? .white : .black
        
        configureMutuals(item)
        
        func configureMutuals(_ item: Detail) {
            viewUrl = URL(string: item.viewUrl)
            detailName.text = item.name
            detailCreator.text = item.creator
            detailReleaseDate.text = convertDate( for: item.releaseDate)
            detailPrice.text = (item.price <= 0) ? HardCoded.free.get() : (HardCoded.dolar.get()).appending(String(item.price))
            detailImage.image = artworkImage
            configureBackgroundColors(averageColor)
        }
        
        switch item.kind{
            case CategoryKind.movie.get(): configureMovie()
            case CategoryKind.music.get(): configureMusic()
            case CategoryKind.ebook.get(): configureEbook()
            case CategoryKind.podcast.get(): configurePodcast()
        default:
            return
        }
        
        func configureMovie() {
            previewUrl = URL(string: item.previewUrl)
            detailPrimaryGenre.text = item.genre
            detailDescription.text = capitalizeUppercaseWords(input: item.longDescription)
            detailLength.text = readableFormatTimeFromMillis(millis: item.length)
            detailCollectionName.text = item.collectionName.isEmpty ? HardCoded.notAvailable.get() : item.collectionName
        }
        func configureMusic() {
            previewUrl = URL(string: item.previewUrl)
            detailPrimaryGenre.text = item.genre
            detailCollectionName.text = item.collectionName
            detailLength.text = readableFormatTimeFromMillis(millis: item.length)
            
            detailTrackInfo.text = String(item.trackNumber)
                .appending(HardCoded.trackSeperator.get())
                .appending(String(item.albumNumber))
        }
        func configureEbook() {
            detailSize.text = convertBytesToGBorMB(item.size)
            detailDescription.text = capitalizeUppercaseWords(input: item.description.withoutHtmlEntities)
            detailGenres.text = item.genreList.joined(separator: HardCoded.seperator.get())
            
            detailRatingCount.text = (item.ratingCount == 0)
            ? HardCoded.noRating.get() : (HardCoded.numberSign.get())
                    .appending( String(item.ratingCount))
            detailRating.text = (item.rating == 0.0)
                ? HardCoded.noRating.get() : String(item.rating)
                .appending(HardCoded.ratingScale.get())
        }
        func configurePodcast() {
            detailContent.text = item.advisory
            detailPrimaryGenre.text = item.genre
            detailCollectionName.text = item.collectionName
            detailLength.text = readableFormatTimeFromSeconds(seconds: item.length)
            detailGenres.text = item.genreList.joined(separator: HardCoded.seperator.get())
            detailEpisodes.text = (HardCoded.numberSign.get())
                .appending(String(item.episodeCount))
        }
        // TODO: Change this, go by subviews and set
        func configureBackgroundColors(_ averageColor: UIColor){
           DispatchQueue.main.async { [weak self] in
               self?.detailContainerView.backgroundColor = averageColor
               self?.detailView.backgroundColor = averageColor
               self?.detailImageContainerView.backgroundColor = averageColor
               self?.detailFieldsView.backgroundColor = averageColor
               self?.detailButtonsView.backgroundColor = averageColor
               if let detailDescriptionView = self?.detailDescriptionView {
                   detailDescriptionView.backgroundColor = averageColor
               }/// Music and Podcast dont have these
               if let detailDescriptionTextView = self?.detailDescriptionTextView {
                   detailDescriptionTextView.backgroundColor = averageColor
               }
           }
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

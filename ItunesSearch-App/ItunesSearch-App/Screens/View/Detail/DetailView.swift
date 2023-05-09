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

protocol DetailViewInterface: AnyObject {
    func configureItem( with item: Detail, _ pair: ImageColorPair)
    func configureMutualFields(_ item: Detail, _ pair: ImageColorPair)
    func configureMovie(_ item: Detail)
    func configureMusic(_ item: Detail)
    func configureEbook(_ item: Detail)
    func configurePodcast(_ item: Detail)
    func configureBackgroundColors(_ averageColor: UIColor)
    func adaptComponentsForDark(_ tintColor: UIColor)
    
    func isColorDark(_ color: UIColor) -> Bool
    func convertDate(for dateValue: String) -> String
    func capitalizeUppercaseWords(input: String) -> String
    func readableFormatTimeFromMillis(millis: Int) -> String
    func readableFormatTimeFromSeconds(seconds: Int) -> String
    func convertBytesToGBorMB(_ bytes: Int) -> String
    func setNavigationBarWith( tintColor color: String)
    func setTextColorOfView(_ color: UIColor)
}

final class DetailView: UIViewController{
    
    let hapticMedium = UIImpactFeedbackGenerator(style: .medium)

    @IBOutlet private weak var detailContainerView: UIView!
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private weak var detailImageContainerView: UIView!
    @IBOutlet private weak var detailFieldsView: UIView!
    @IBOutlet private weak var detailDescriptionView: UIView!
    @IBOutlet private weak var detailButtonsView: UIView!
    @IBOutlet private weak var detailDescriptionTextView: UITextView!
    /// above is added for colorization
    @IBOutlet weak var musicPreviewButton: UIButton!
    @IBOutlet private weak var viewButton: UIButton!
    @IBOutlet private weak var moviePreviewButton: UIButton!
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
    
    private lazy var viewModel = DetailViewModel()
        
    private var item: Detail?
    var id = 0
    private var isAudioPlaying = false

    private let webView = WKWebView()
    private var player: AVPlayer?
    var playerItem: AVPlayerItem?
    private var playerViewController: AVPlayerViewController?
    private var viewUrl: URL?
    private var previewUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
    }
        
    /* Button Actions */
    @IBAction func viewButtonClicked(_ sender: Any) {
        hapticFeedbackMedium()
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
        hapticFeedbackMedium()
        let player = AVPlayer(url: previewUrl!)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        present(playerViewController!, animated: true) { player.play() }
    }
    
    @IBAction func musicPreviewButtonClicked(_ sender: Any) {
        hapticFeedbackMedium()
        guard let previewUrl = previewUrl else { return }
        
        if isAudioPlaying{
            player?.pause()
            removeAudioRelated()
        } else {
            playerItem = AVPlayerItem(url: previewUrl)
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            
            addPlayIndicator()
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
        isAudioPlaying.toggle()
    }
}

extension DetailView: DetailViewInterface {
    
    func configureItem( with item: Detail, _ pair: ImageColorPair){
        viewModel.configureItem(with: item, pair)
    }
    
    func configureMutualFields(_ item: Detail, _ pair: ImageColorPair) {
        
        configureBackgroundColors(pair.color)
        detailImage.image = pair.image
        viewUrl = URL(string: item.viewUrl)
        detailName.text = item.name
        detailCreator.text = item.creator
        detailReleaseDate.text = viewModel.convertDate(item.releaseDate)
        detailPrice.text = viewModel.handlePrice(item.price)
    }
    
    func configureMovie(_ item: Detail) {
        
        previewUrl = URL(string: item.previewUrl)
        detailPrimaryGenre.text = item.genre
        detailDescription.text = viewModel.handleDescription(item.longDescription)
        detailLength.text = viewModel.handleTime(millis: item.length)
        detailCollectionName.text = viewModel.handleCollectionName(item.collectionName)
    }
    func configureMusic(_ item: Detail) {
        
        previewUrl = URL(string: item.previewUrl)
        detailPrimaryGenre.text = item.genre
        detailCollectionName.text = viewModel.handleCollectionName(item.collectionName)
        detailLength.text = viewModel.handleTime(millis: item.length)
        detailTrackInfo.text = viewModel.constructTrackInfo(item.trackNumber, item.albumNumber)
 
    }
    func configureEbook(_ item: Detail) {
        detailSize.text = viewModel.handleByteRepresentation(item.size)
        detailDescription.text = viewModel.handleDescription(item.description.withoutHtmlEntities)
        detailGenres.text = viewModel.handleJoin(item.genreList)
        detailRatingCount.text = viewModel.handleRating(item.ratingCount)
        detailRating.text = viewModel.handleRating(item.rating)
    }
    func configurePodcast(_ item: Detail) {
        detailContent.text = item.advisory
        detailPrimaryGenre.text = item.genre
        detailCollectionName.text = viewModel.handleCollectionName(item.collectionName)
        // logic
        detailLength.text = viewModel.handleTime(seconds: item.length)
        detailGenres.text = viewModel.handleJoin(item.genreList)
        detailEpisodes.text = viewModel.constructEpisodeInfo(item.episodeCount)
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
    
    func setNavigationBarWith( tintColor colorName: String) {
        navigationController?.navigationBar.tintColor = UIColor(named: colorName)
    }
    func setTextColorOfView(_ color: UIColor) {
        detailView.setAllTextColors(color)
    }
    
    /// Interface Helpers
    func adaptComponentsForDark(_ tintColor: UIColor){
        DispatchQueue.main.async { [weak self] in
            if let view = self?.viewButton { view.tintColor = tintColor }
            if let movie = self?.moviePreviewButton { movie.tintColor = tintColor }
            if let music = self?.musicPreviewButton { music.tintColor = tintColor }
            if let navBar = self?.navigationController?.navigationBar { navBar.tintColor = .lightGray }
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) { /// used for music preview
        removeAudioRelated()
        isAudioPlaying.toggle()
    }
    
}

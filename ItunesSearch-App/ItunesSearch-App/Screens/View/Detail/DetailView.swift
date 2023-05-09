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
    func toggleAudioOff()
    func toggleAudioOn(_ url: URL)
    func addPlayIndicator()
    func removeAudioRelated()
}

final class DetailView: UIViewController{
    
    let hapticMedium = UIImpactFeedbackGenerator(style: .medium)

    @IBOutlet private weak var view_FullContainer: UIView!
    @IBOutlet private weak var view_FullView: UIView!
    @IBOutlet private weak var view_ImageContainer: UIView!
    @IBOutlet private weak var view_Fields: UIView!
    @IBOutlet private weak var view_Description: UIView!
    @IBOutlet private weak var view_Buttons: UIView!
    /// above is added for colorization
    @IBOutlet private weak var imageView_Image: UIImageView!
    @IBOutlet private weak var textView_Description: UITextView!
    
    @IBOutlet private weak var button_MusicPreview: UIButton!
    @IBOutlet private weak var button_View: UIButton!
    @IBOutlet private weak var button_MoviePreview: UIButton!

    @IBOutlet private weak var label_Name: UILabel!
    @IBOutlet private weak var label_Creator: UILabel!
    @IBOutlet private weak var label_CollectionName: UILabel!
    @IBOutlet private weak var label_ReleaseDate: UILabel!
    @IBOutlet private weak var label_PrimaryGenre: UILabel!
    @IBOutlet private weak var label_Price: UILabel!
    @IBOutlet private weak var label_Length: UILabel!
    @IBOutlet private weak var label_Size: UILabel!
    @IBOutlet private weak var label_RatingCount: UILabel!
    @IBOutlet private weak var label_Rating: UILabel!
    @IBOutlet private weak var label_Genres: UILabel!
    @IBOutlet private weak var label_Content: UILabel!
    @IBOutlet private weak var label_Episodes: UILabel!
    @IBOutlet private weak var label_TrackInfo: UILabel!
    
    private lazy var viewModel = DetailViewModel()
        
    private var item: Detail?
    var id = 0

    private let webView = WKWebView()
    private var player: AVPlayer?
    private var audioPlayerItem: AVPlayerItem?
    private var moviePlayerVC: AVPlayerViewController?
    private var viewUrl: URL?
    private var previewUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
    }
        
    @IBAction func viewButtonClicked(_ sender: Any) {
        hapticFeedbackMedium()
        guard let viewUrl = viewUrl else { return }
        let webViewVC = UIViewController()
        webViewVC.view = webView
        let request = URLRequest(url: viewUrl)
        webView.load(request)
        let scrollView = webView.scrollView
        let topInset = navigationController?.navigationBar.frame.minY ?? 0
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    @IBAction func moviePreviewButtonClicked(_ sender: Any) {
        hapticFeedbackMedium()
        guard let previewUrl = previewUrl else { return }
        let player = AVPlayer(url: previewUrl)
        moviePlayerVC = AVPlayerViewController()
        moviePlayerVC?.player = player
        present(moviePlayerVC!, animated: true) { player.play() }
    }
    
    @IBAction func musicPreviewButtonClicked(_ sender: Any) {
        hapticFeedbackMedium()
        guard let previewUrl = previewUrl else { return }
        viewModel.musicPreviewButtonClicked( previewUrl)
    }
}

extension DetailView: DetailViewInterface {
    
    func configureItem( with item: Detail, _ pair: ImageColorPair){
        viewModel.configureItem(with: item, pair)
    }
    
    func configureMutualFields(_ item: Detail, _ pair: ImageColorPair) {
        
        configureBackgroundColors(pair.color)
        imageView_Image.image = pair.image
        viewUrl = URL(string: item.viewUrl)
        label_Name.text = item.name
        label_Creator.text = item.creator
        label_ReleaseDate.text = viewModel.convertDate(item.releaseDate)
        label_Price.text = viewModel.handlePrice(item.price)
    }
    
    func configureMovie(_ item: Detail) {
        
        previewUrl = URL(string: item.previewUrl)
        label_PrimaryGenre.text = item.genre
        textView_Description.text = viewModel.handleDescription(item.longDescription)
        label_Length.text = viewModel.handleTime(millis: item.length)
        label_CollectionName.text = viewModel.handleCollectionName(item.collectionName)
    }
    func configureMusic(_ item: Detail) {
        
        previewUrl = URL(string: item.previewUrl)
        label_PrimaryGenre.text = item.genre
        label_CollectionName.text = viewModel.handleCollectionName(item.collectionName)
        label_Length.text = viewModel.handleTime(millis: item.length)
        label_TrackInfo.text = viewModel.constructTrackInfo(item.trackNumber, item.albumNumber)
 
    }
    func configureEbook(_ item: Detail) {
        label_Size.text = viewModel.handleByteRepresentation(item.size)
        textView_Description.text = viewModel.handleDescription(item.description.withoutHtmlEntities)
        label_Genres.text = viewModel.handleJoin(item.genreList)
        label_RatingCount.text = viewModel.handleRating(item.ratingCount)
        label_Rating.text = viewModel.handleRating(item.rating)
    }
    func configurePodcast(_ item: Detail) {
        label_Content.text = item.advisory
        label_PrimaryGenre.text = item.genre
        label_CollectionName.text = viewModel.handleCollectionName(item.collectionName)
        label_Length.text = viewModel.handleTime(seconds: item.length)
        label_Genres.text = viewModel.handleJoin(item.genreList)
        label_Episodes.text = viewModel.constructEpisodeInfo(item.episodeCount)
    }
    
    // TODO: Change this, go by subviews and set
    func configureBackgroundColors(_ averageColor: UIColor){
       DispatchQueue.main.async { [weak self] in
           self?.view_FullContainer.backgroundColor = averageColor
           self?.view_FullView.backgroundColor = averageColor
           self?.view_ImageContainer.backgroundColor = averageColor
           self?.view_Fields.backgroundColor = averageColor
           self?.view_Buttons.backgroundColor = averageColor
           if let descriptionView = self?.view_Description {
               descriptionView.backgroundColor = averageColor
           }
           if let descriptionTextView = self?.textView_Description {
               descriptionTextView.backgroundColor = averageColor
           }
       }
    }
    
    func setNavigationBarWith( tintColor colorName: String) {
        navigationController?.navigationBar.tintColor = UIColor(named: colorName)
    }
    func setTextColorOfView(_ color: UIColor) {
        view_FullView.setAllTextColors(color)
    }
    
    func toggleAudioOff() {
        player?.pause()
        removeAudioRelated()
    }
    
    func toggleAudioOn(_ url: URL ) {
        audioPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: audioPlayerItem)
        player?.play()
        
        addPlayIndicator()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: audioPlayerItem)
    }
    
    func addPlayIndicator() {
        let playIndicator = UIActivityIndicatorView(style: .medium)
        playIndicator.color = AppConstants.activityIndicatorColor
        self.button_MusicPreview.setTitle(HardCoded.audioEmoji.get(), for: .normal)
        self.button_MusicPreview.addSubview(playIndicator)
        playIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playIndicator.leadingAnchor.constraint(equalTo: button_MusicPreview.titleLabel!.trailingAnchor, constant: 8),
            playIndicator.centerYAnchor.constraint(equalTo: self.button_MusicPreview.centerYAnchor),
        ])
        playIndicator.startAnimating()
    }
    func removeAudioRelated(){
        button_MusicPreview.setTitle(HardCoded.previewText.get(), for: .normal)
        button_MusicPreview.subviews.forEach { subview in
            if let playIndicator = subview as? UIActivityIndicatorView {
                playIndicator.stopAnimating()
                playIndicator.removeFromSuperview()
            }
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: audioPlayerItem)
    }
    
    /// Interface Helpers
    func adaptComponentsForDark(_ tintColor: UIColor){
        DispatchQueue.main.async { [weak self] in
            if let view = self?.button_View { view.tintColor = tintColor }
            if let movie = self?.button_MoviePreview { movie.tintColor = tintColor }
            if let music = self?.button_MusicPreview { music.tintColor = tintColor }
            if let navBar = self?.navigationController?.navigationBar { navBar.tintColor = .lightGray }
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        removeAudioRelated()
        viewModel.toggleAudio()
    }
    
}

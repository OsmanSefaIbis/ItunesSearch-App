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

final class DetailView: UIViewController{
    
    let hapticMedium = UIImpactFeedbackGenerator(style: .medium)

    @IBOutlet private weak var view_FullContainer: UIView!
    @IBOutlet private weak var view_FullView: UIView!
    @IBOutlet private weak var view_ImageContainer: UIView!
    @IBOutlet private weak var view_Fields: UIView! // todaysearchTODO: Too much, change configureBackgroundColors() --> to eliminate these, add a recursive solution
    @IBOutlet private weak var view_Description: UIView!
    @IBOutlet private weak var view_Buttons: UIView!
    /// above is added for colorization
    @IBOutlet private weak var imageView_Image: UIImageView!
    @IBOutlet private weak var textView_Description: UITextView!
    
    @IBOutlet private weak var button_MusicPreview: UIButton!
    @IBOutlet private weak var button_MoviePreview: UIButton!
    @IBOutlet private weak var button_WebView: UIButton!

    @IBOutlet private weak var label_Name: UILabel!
    @IBOutlet private weak var label_Creator: UILabel!
    @IBOutlet private weak var label_CollectionName: UILabel!
    @IBOutlet private weak var label_ReleaseDate: UILabel!
    @IBOutlet private weak var label_PrimaryGenre: UILabel!
    @IBOutlet private weak var label_Price: UILabel!                //searchTODO: Too much, what should i do, or is this normal idk?
    @IBOutlet private weak var label_Length: UILabel!
    @IBOutlet private weak var label_Size: UILabel!
    @IBOutlet private weak var label_RatingCount: UILabel!
    @IBOutlet private weak var label_Rating: UILabel!
    @IBOutlet private weak var label_Genres: UILabel!
    @IBOutlet private weak var label_Content: UILabel!
    @IBOutlet private weak var label_Episodes: UILabel!
    @IBOutlet private weak var label_TrackInfo: UILabel!
    
    let spinnerOfWeb = UIActivityIndicatorView(style: .large)
    
    var viewModel: DetailViewModel?
        
    private var item: Detail?

    private lazy var webView = WKWebView()
    private var player: AVPlayer?
    private var audioPlayerItem: AVPlayerItem?
    private var moviePlayerVC: AVPlayerViewController?
    private var viewUrl: URL?
    private var previewUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func viewButtonClicked(_ sender: Any) {
        hapticFeedbackMedium()
        guard let viewUrl = viewUrl else { return }
        webView.load(URLRequest(url: viewUrl))
        webView.navigationDelegate = self
        
        let webVC = UIViewController()
        webVC.view = webView
        webVC.view.addSubview(spinnerOfWeb)
        spinnerOfWeb.color = ConstantsApp.spinnerColor
        spinnerOfWeb.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinnerOfWeb.centerXAnchor.constraint(equalTo: webVC.view.centerXAnchor),
            spinnerOfWeb.centerYAnchor.constraint(equalTo: webVC.view.centerYAnchor)
        ])
        
        navigationController?.pushViewController(webVC, animated: true)
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
        viewModel?.musicPreviewButtonClicked( previewUrl)
    }
}

extension DetailView: DetailViewContract {
    
    // todayTODO: Apply below to resolve the issue with code trying to access the outlets before they are fully initialized.
    // todayFIXME: Device and simulator are behaving inconsistent, simulator arises timing related nil of IBOutlet
    
    // todayTODO: Learn differences of the device and simulator capabilities. What might go wrong, what should you know beforehand?
    /*
     One way to debug this issue is to add print statements throughout your code to track the lifecycle of the outlets. For example, you could add print statements to the viewDidLoad() and viewDidAppear() methods to check if the outlets are being initialized properly. You can also add print statements in the completion handlers of any asynchronous operations that affect the outlets, such as network requests or image loading.

     Another approach is to use breakpoints in Xcode to pause the execution of your code at specific points and inspect the state of your variables. You can add a breakpoint to the line of code that is causing the crash, and then step through the code line by line to see where the nil value is coming from. This can help you pinpoint the exact moment when the outlet is being accessed before it's fully initialized.

     In addition, you can use Xcode's debug navigator to monitor the memory usage of your app and track any memory-related issues that could be affecting the initialization of your outlets.

     Finally, you can try simplifying your code by removing any unnecessary logic and reducing the complexity of your view controller to isolate the issue. This can help you identify any potential race conditions or threading issues that could be causing the crash.
     */
        
    func configureView(with item: Detail, _ pair: ImageColorPair, completion: (() -> Void)?) {
        viewModel?.configureItem(with: item, pair){
            completion?()
        }
    }
    
    func configureMutualFields(_ item: Detail, _ pair: ImageColorPair) {
        
        configureBackgroundColors(pair.color)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.imageView_Image.image = pair.image
            self.viewUrl = URL(string: item.viewUrl)
            self.label_Name.text = item.name
            self.label_Creator.text = item.creator
            self.label_ReleaseDate.text = self.viewModel?.convertDate(item.releaseDate)
            self.label_Price.text = self.viewModel?.handlePrice(item.price)
        }
    }
    
    func configureMovie(_ item: Detail) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.previewUrl = URL(string: item.previewUrl)
            self.label_PrimaryGenre.text = item.genre
            self.textView_Description.text = self.viewModel?.handleDescription(item.longDescription)
            self.label_Length.text = self.viewModel?.handleTime(millis: item.length)
            self.label_CollectionName.text = self.viewModel?.handleCollectionName(item.collectionName)
        }
    }
    func configureMusic(_ item: Detail) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.previewUrl = URL(string: item.previewUrl)
            self.label_PrimaryGenre.text = item.genre
            self.label_CollectionName.text = self.viewModel?.handleCollectionName(item.collectionName)
            self.label_Length.text = self.viewModel?.handleTime(millis: item.length)
            self.label_TrackInfo.text = self.viewModel?.constructTrackInfo(item.trackNumber, item.albumNumber)
        }
 
    }
    func configureEbook(_ item: Detail) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.label_Size.text = self.viewModel?.handleByteRepresentation(item.size)
            self.textView_Description.text = self.viewModel?.handleDescription(item.description.withoutHtmlEntities)
            self.label_Genres.text = self.viewModel?.handleJoin(item.genreList)
            self.label_RatingCount.text = self.viewModel?.handleRating(item.ratingCount)
            self.label_Rating.text = self.viewModel?.handleRating(item.rating)
        }
    }
    func configurePodcast(_ item: Detail) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.label_Content.text = item.advisory
            self.label_PrimaryGenre.text = item.genre
            self.label_CollectionName.text = self.viewModel?.handleCollectionName(item.collectionName)
            self.label_Length.text = self.viewModel?.handleTime(seconds: item.length)
            self.label_Genres.text = self.viewModel?.handleJoin(item.genreList)
            self.label_Episodes.text = self.viewModel?.constructEpisodeInfo(item.episodeCount)
        }
    }
    
    // todayTODO: Change this, go by subviews and set
    func configureBackgroundColors(_ averageColor: UIColor){
       DispatchQueue.main.async { [weak self] in
           guard let self else { return }
           self.view_FullContainer.backgroundColor = averageColor
           self.view_FullView.backgroundColor = averageColor
           self.view_ImageContainer.backgroundColor = averageColor
           self.view_Fields.backgroundColor = averageColor
           self.view_Buttons.backgroundColor = averageColor
           if let descriptionView = self.view_Description {
               descriptionView.backgroundColor = averageColor
           }
           if let descriptionTextView = self.textView_Description {
               descriptionTextView.backgroundColor = averageColor
           }
       }
    }
    
    func setNavigationBarWith( tintColor colorName: String) {
        navigationController?.navigationBar.tintColor = UIColor(named: colorName)
    }
    func setTextColorOfView(_ color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view_FullView.setAllTextColors(color)
        }
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
        playIndicator.color = ConstantsApp.spinnerColor
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
            guard let self else { return }
            if let view = self.button_WebView { view.tintColor = tintColor }
            if let movie = self.button_MoviePreview { movie.tintColor = tintColor }
            if let music = self.button_MusicPreview { music.tintColor = tintColor }
            if let navBar = self.navigationController?.navigationBar { navBar.tintColor = .lightGray }
        }
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        removeAudioRelated()
        viewModel?.toggleAudio()
    }
    
}

//
//  DetailView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import UIKit
import WebKit
import AVKit

final class DetailVC: UIViewController{
    
    let hapticMedium = UIImpactFeedbackGenerator(style: .medium)

    @IBOutlet weak var view_FullContainer: UIView!
    @IBOutlet weak var view_FullView: UIView!
    @IBOutlet weak var view_ImageContainer: UIView!
    @IBOutlet weak var view_Fields: UIView!
    @IBOutlet weak var view_Description: UIView!
    @IBOutlet weak var view_Buttons: UIView!
    /// above is added for colorization
    @IBOutlet weak var imageView_Image: UIImageView!
    @IBOutlet weak var textView_Description: UITextView!
    
    @IBOutlet weak var button_MusicPreview: UIButton!
    @IBOutlet weak var button_MoviePreview: UIButton!
    @IBOutlet weak var button_WebView: UIButton!

    @IBOutlet weak var label_Name: UILabel!
    @IBOutlet weak var label_Creator: UILabel!
    @IBOutlet weak var label_CollectionName: UILabel!
    @IBOutlet weak var label_ReleaseDate: UILabel!
    @IBOutlet weak var label_PrimaryGenre: UILabel!
    @IBOutlet weak var label_Price: UILabel!
    @IBOutlet weak var label_Length: UILabel!
    @IBOutlet weak var label_Size: UILabel!
    @IBOutlet weak var label_RatingCount: UILabel!
    @IBOutlet weak var label_Rating: UILabel!
    @IBOutlet weak var label_Genres: UILabel!
    @IBOutlet weak var label_Content: UILabel!
    @IBOutlet weak var label_Episodes: UILabel!
    @IBOutlet weak var label_TrackInfo: UILabel!
    
    let spinnerOfWeb = UIActivityIndicatorView(style: .large)
    
    var viewModel: DetailVM?
        
    var item: Detail?

    lazy var webView = WKWebView()
    var player: AVPlayer?
    var audioPlayerItem: AVPlayerItem?
    var moviePlayerVC: AVPlayerViewController?
    var viewUrl: URL?
    var previewUrl: URL?
    
    override func viewDidLoad() { 
        super.viewDidLoad()
    }
    
    @IBAction func viewButtonClicked(_ sender: Any) {
        if let status = viewModel?.isAudioActive(), status { toggleAudioOff() ; viewModel?.toggleAudio() }
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


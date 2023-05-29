//
//  DetailVC+DetailViewContract.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 29.05.2023.
//

import UIKit
import AVKit


extension DetailVC: DetailViewContract {
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
    }

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
    
    func isColorDark(_ color: UIColor) -> Bool {
        
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let brightness = (red + green + blue) / 3.0
        return brightness < 0.2 // critical
    }
    
    func adaptComponentsForDark(_ tintColor: UIColor){
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let view = self.button_WebView { view.tintColor = tintColor }
            if let movie = self.button_MoviePreview { movie.tintColor = tintColor }
            if let music = self.button_MusicPreview { music.tintColor = tintColor }
            if let navBar = self.navigationController?.navigationBar { navBar.tintColor = .lightGray }
        }
    }
    
    func setTextColorOfView(_ color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view_FullView.setAllTextColors(color)
        }
    }
    
    func setNavigationBarWith( tintColor colorName: String) {
        navigationController?.navigationBar.tintColor = UIColor(named: colorName)
    }
    
    func convertDate(for dateValue: String) -> String {
        
        let inputDF = DateFormatter()
        inputDF.dateFormat = HardCoded.apiDateFormat.get()
        
        guard let inputDate = inputDF.date(from: dateValue) else {
            if dateValue.isEmpty {
                return "N/A"
            }else{
                fatalError(HardCoded.errorPromptDate.get())
            }
        }
        let outputDF = DateFormatter()
        outputDF.dateFormat = HardCoded.convertedDateFormat.get()
        outputDF.locale = Locale(identifier: HardCoded.locale_US.get())
        let output = outputDF.string(from: inputDate)
        return output
    }
    
    func capitalizeUppercaseWords(input: String) -> String {
        
        let words = input.components(separatedBy: " ")
        var capitalizedWords = [String]()
        
        for word in words {
            if word == word.uppercased() {
                capitalizedWords.append(word.capitalized)
            } else {
                capitalizedWords.append(word)
            }
        }
        return capitalizedWords.joined(separator: " ")
    }
    
    func readableFormatTimeFromMillis(millis: Int) -> String {
        
        let totalSeconds = Int(millis / 1000)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        var timeComponents = [String]()
        
        if hours > 0 {
            timeComponents.append("\(hours)h")
        }
        if minutes > 0 {
            timeComponents.append("\(minutes)m")
        }
        if seconds > 0 {
            timeComponents.append("\(seconds)s")
        }
        if timeComponents.count == 0 {
            timeComponents.append(HardCoded.notAvailable.get())
        }
        return timeComponents.joined(separator: " ")
    }
    
    func readableFormatTimeFromSeconds(seconds: Int) -> String {
        
        let totalSeconds = seconds
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        var timeComponents = [String]()
        if hours > 0 {
            timeComponents.append("\(hours)h")
        }
        
        if minutes > 0 {
            timeComponents.append("\(minutes)m")
        }
        
        if seconds > 0 {
            timeComponents.append("\(seconds)s")
        }
        
        if timeComponents.count == 0 {
            timeComponents.append(HardCoded.notAvailable.get())
        }
        return timeComponents.joined(separator: " ")
    }
 
    func convertBytesToGBorMB(_ bytes: Int) -> String {
        
        let gigabytes = Double(bytes) / 1_000_000_000
        if gigabytes >= 1 {
            return String(format: "%.2f GB", gigabytes)
        } else {
            let megabytes = Double(bytes) / 1_000_000
            return String(format: "%.2f MB", megabytes)
        }
    }
    
    func toggleAudioOff() {
        DispatchQueue.main.async { [weak self] in
            self?.player?.pause()
            self?.removeAudioRelated()
        }
    }
    
    func toggleAudioOn(_ url: URL ) {
        audioPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: audioPlayerItem)
        DispatchQueue.main.async { [weak self] in
            self?.player?.play()
            self?.addPlayIndicator()
        }
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
}

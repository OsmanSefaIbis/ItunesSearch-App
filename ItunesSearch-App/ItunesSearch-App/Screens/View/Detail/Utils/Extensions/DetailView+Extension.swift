//
//  DetailView+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import UIKit

extension DetailView{
    
    func convertBytesToGBorMB(_ bytes: Int) -> String {
        let gigabytes = Double(bytes) / 1_000_000_000
        if gigabytes >= 1 {
            return String(format: "%.2f GB", gigabytes)
        } else {
            let megabytes = Double(bytes) / 1_000_000
            return String(format: "%.2f MB", megabytes)
        }
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
    
    func isColorDark(_ color: UIColor) -> Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let brightness = (red + green + blue) / 3.0
        return brightness < 0.2 // critical
    }
    
    func convertDate(for dateValue: String) -> String{
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
    func addPlayIndicator() {
        let playIndicator = UIActivityIndicatorView(style: .medium)
        playIndicator.color = AppConstants.activityIndicatorColor
        self.musicPreviewButton.setTitle(HardCoded.audioEmoji.get(), for: .normal)
        self.musicPreviewButton.addSubview(playIndicator)
        playIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playIndicator.leadingAnchor.constraint(equalTo: musicPreviewButton.titleLabel!.trailingAnchor, constant: 8),
            playIndicator.centerYAnchor.constraint(equalTo: self.musicPreviewButton.centerYAnchor),
        ])
        playIndicator.startAnimating()
    }
    func removeAudioRelated(){
        musicPreviewButton.setTitle(HardCoded.previewButtonText.get(), for: .normal)
        musicPreviewButton.subviews.forEach { subview in
            if let playIndicator = subview as? UIActivityIndicatorView {
                playIndicator.stopAnimating()
                playIndicator.removeFromSuperview()
            }
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    func hapticFeedbackMedium() {
        hapticMedium.prepare()
        hapticMedium.impactOccurred(intensity: 1.0)
    }
}


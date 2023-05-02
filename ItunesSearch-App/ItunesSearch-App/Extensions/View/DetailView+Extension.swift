//
//  DetailView+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

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
        let remainderSeconds = totalSeconds % 60
        let totalMinutes = totalSeconds / 60
        let totalHours = totalMinutes / 60
        
        var timeComponents = [String]()
        
        if totalHours > 0 {
            timeComponents.append("\(totalHours)h")
        }
        
        if totalMinutes > 0 {
            timeComponents.append("\(totalMinutes)m")
        }
        
        if totalSeconds > 0 {
            timeComponents.append("\(remainderSeconds)s")
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
    
    func convertDate(for dateValue: String) -> String{
        let inputDF = DateFormatter()
        inputDF.dateFormat = HardCoded.apiDateFormat.get()
        
        guard let inputDate = inputDF.date(from: dateValue) else {
            if dateValue.isEmpty {
                return "N/A"
            }else{
                fatalError(HardCoded.errorPromptOne.get())
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
    
}


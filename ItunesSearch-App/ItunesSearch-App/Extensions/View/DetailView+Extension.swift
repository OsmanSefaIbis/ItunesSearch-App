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
    
    func formatTimeFromMinutes(minutes: Int) -> String {
        let totalMinutes = minutes
        let minutes = totalMinutes % 60
        let hours = totalMinutes / 60
        
        var timeComponents = [String]()
        
        if hours > 0 {
            timeComponents.append(String(format: "%02d", hours))
        }
        
        if minutes > 0 {
            timeComponents.append(String(format: "%02d", minutes))
        }
        
        if timeComponents.count == 0 {
            timeComponents.append(HardCoded.zeroColonSeperator.get())
        }
        
        return timeComponents.joined(separator: HardCoded.colonSeperator.get())
    }
    
    func formatTimeFromMillis(millis: Int) -> String {
        let totalSeconds = Int(millis / 1000)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        
        var timeComponents = [String]()
        
        if hours > 0 {
            timeComponents.append(String(format: "%02d", hours))
        }
        
        if hours == 0 && minutes > 0 {
            timeComponents.append(String(format: "%02d", minutes))
        }
        
        if seconds > 0 {
            timeComponents.append(String(format: "%02d", seconds))
        }
        
        if timeComponents.count == 0 {
            timeComponents.append(HardCoded.zeroColonSeperator.get())
        }
        
        return timeComponents.joined(separator: HardCoded.colonSeperator.get())
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
    
}


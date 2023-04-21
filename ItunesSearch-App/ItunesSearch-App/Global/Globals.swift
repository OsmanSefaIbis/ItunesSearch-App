//
//  Globals.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 15.04.2023.
//

import Foundation

let requestLimit = 20

func convertDate(for dateValue: String) -> String{
    let inputDF = DateFormatter()
    inputDF.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    guard let inputDate = inputDF.date(from: dateValue) else {
        fatalError("Invalid date string")
    }
    let outputDF = DateFormatter()
    outputDF.dateFormat = "MMMM d, yyyy"
    outputDF.locale = Locale(identifier: "en_US")
    let output = outputDF.string(from: inputDate)
    return output
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
        timeComponents.append("0:0")
    }
    
    return timeComponents.joined(separator: ":")
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
        timeComponents.append("0:0")
    }
    
    return timeComponents.joined(separator: ":")
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

func changeImageURL(_ urlString: String, withDimension dimension: Int) -> String? {
    guard var urlComponents = URLComponents(string: urlString) else {
        return nil
    }
    if urlComponents.path.hasSuffix("/100x100bb.jpg") {
        urlComponents.path = urlComponents.path.replacingOccurrences(of: "/100x100bb.jpg", with: "/\(dimension)x\(dimension)bb.jpg")
        return urlComponents.string
    } else {
        return urlComponents.string
    }
}

func composeUrlForDetail(_ term: String, _ media: Category, _ offset: Int) -> String{
    let termParam = "term=".appending(term)
    let mediaParam = "&media=".appending(media.rawValue)
    let baseUrl = Api.url.scheme + Api.url.domain + Api.url.searchPath
    let urlCompose = baseUrl + termParam + mediaParam + Api.url.limit + Api.url.offsetLimit + String(offset)
    
    return urlCompose
}

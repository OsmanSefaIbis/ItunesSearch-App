//
//  Globals.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 15.04.2023.
//

import Foundation

func convertData(for dateValue: String) -> String{
    let inputDF = DateFormatter()
    inputDF.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    guard let inputDate = inputDF.date(from: dateValue) else {
        fatalError("Invalid date string")
    }
    let outputDF = DateFormatter()
    outputDF.dateFormat = "MMMM d, yyyy"
    let output = outputDF.string(from: inputDate)
    return output
}

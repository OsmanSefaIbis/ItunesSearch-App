//
//  SearchCell+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

extension SearchCell {
    
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
        outputDF.dateFormat = HardCoded.convertedDateFormatShort.get()
        outputDF.locale = Locale(identifier: HardCoded.locale_US.get())
        let output = outputDF.string(from: inputDate)
        return output
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
}

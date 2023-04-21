//
//  HardCoded.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

enum HardCoded: String{
    case cellIdentifier, getRequest,free, dolar, trackSeperator, seperator,
         noRating, numberSign, ratingScale, termParam, mediaParam, idParam,
         fetchSingularDataError, fetchDataWithError, apiDateFormat, convertedDateFormat, locale_US,
         colonSeperator, zeroColonSeperator, errorPromptOne, segmentedControlError
    
    func get() -> String{
        switch self{
            case .cellIdentifier: return "SearchCell"
            case .getRequest: return "GET"
            case .free: return "Free"
            case .dolar: return "$ "
            case .trackSeperator: return " /"
            case .seperator: return ", "
            case .noRating: return "No Rating"
            case .numberSign: return "# "
            case .ratingScale: return " /5"
            case .termParam: return "term="
            case .mediaParam: return "&media="
            case .idParam: return "id="
            case .apiDateFormat: return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .convertedDateFormat: return "MMMM d, yyyy"
            case .locale_US: return "en_US"
            case .colonSeperator: return ":"
            case .zeroColonSeperator: return "0:0"
            case .errorPromptOne: return "Invalid date string"
            case .fetchDataWithError:
                return "Error occured with fetchDataWith() - Cause: Decoding Error --> "
            case .fetchSingularDataError:
                return "Error occured with fetchSingularData() - Cause: Decoding Error --> "
            case .segmentedControlError :
                return "Error occured with segmentedControlValueChanged()"
        }
    }
}


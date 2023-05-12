//
//  HardCoded.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

enum HardCoded: String {
    
    case getRequest, collectionViewHeaderPhrase, previewText, free,
         dolar, notAvailable, trackSeperator, seperator, noRating, numberSign, ratingScale,
         termParam, limitParam, mediaParam, rssParam, countryParam, jsonParam,  idParam,
         fetchSingularDataError, fetchDataWithError, apiDateFormat, convertedDateFormat,
         convertedDateFormatShort, locale_US, colonSeperator, errorPromptDate, audioEmoji,
         segmentedControlError, invalidJSON, offlinePrompt, loadingReusableName,
         headerReusableName, loadingReusableIdentifier, headerReusableIdentifier,
         offLineAlertTitlePrompt, offLineActionTitlePrompt, errorPromptElementKind, errorPromptKind
    
    func get() -> String {
        switch self {
            case .getRequest: return "GET" // delete
            case .collectionViewHeaderPhrase: return " Top Picks"
            case .previewText: return "Preview"
            case .audioEmoji: return "🔊"
            case .free: return "Free"
            case .dolar: return "$ "
            case .notAvailable: return "N/A"
            case .trackSeperator: return " /"
            case .seperator: return ", "
            case .noRating: return "No Rating"
            case .numberSign: return "# "
            case .ratingScale: return " /5"
            case .termParam: return "term="  // delete
            case .limitParam: return "limit=100/" // delete
            case .mediaParam: return "&media=" //delete
            case .rssParam: return "rss/" //delete
            case .countryParam: return "us/" // delete
            case .jsonParam: return "json" // delete
            case .idParam: return "id=" // delete
            case .apiDateFormat: return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .convertedDateFormat: return "MMMM d, yyyy"
            case .convertedDateFormatShort: return "MMM d, yyyy"
            case .locale_US: return "en_US"
            case .colonSeperator: return " : "
            case .errorPromptDate: return "Invalid date string"
            case .errorPromptElementKind: return "Unexpected element kind"
            case .errorPromptKind: return "Unexpected kind"
            case .offlinePrompt: return "Check internet connectivity !"
            case .offLineAlertTitlePrompt: return "Warning"
            case .offLineActionTitlePrompt: return "Ok"
            case .loadingReusableName: return "LoadingReusableView"
            case .loadingReusableIdentifier: return "loadingresuableviewid"
            case .headerReusableName: return "HeaderReusableView"
            case .headerReusableIdentifier: return "headerreusableviewid"
            case .fetchDataWithError: return "Error occured with fetchDataWith() - Cause: Decoding Error --> "
            case .fetchSingularDataError: return "Error occured with fetchSingularData() - Cause: Decoding Error --> "
            case .segmentedControlError : return "Error occured with segmentedControlValueChanged()"
            case .invalidJSON: return "Invalid JSON data"
        }
    }
}




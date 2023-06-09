//
//  HardCoded.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 21.04.2023.
//

import Foundation

enum HardCoded: String {
    
    case searchCell,accentColor, collectionViewHeaderTopPicksPhrase, collectionViewHeaderNoResultsPhrase, collectionViewFooterPhrase,
         previewText, free, dolar, notAvailable, trackSeperator, seperator, noRating, numberSign,
         ratingScale, fetchSingularDataError, fetchDataWithError, apiDateFormat, convertedDateFormat,
         convertedDateFormatShort, locale_US, colonSeperator, errorPromptDate, audioEmoji,
         segmentedControlError, invalidJSON, offlinePrompt, loadingReusableName,
         headerReusableName, footerReusableName, footerReusableIdentifier, loadingReusableIdentifier, headerReusableIdentifier,
         offLineAlertTitlePrompt, offLineActionTitlePrompt, errorPromptElementKind,
         errorPromptKind, dimensionHundred
    
    func get() -> String {
        
        switch self {
            case .searchCell: return "SearchCell"
            case .accentColor: return "AccentColor"
            case .collectionViewHeaderTopPicksPhrase: return " Top Picks"
            case .collectionViewHeaderNoResultsPhrase: return " No Results Found "
            case .collectionViewFooterPhrase: return " Results Found "
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
            case .dimensionHundred: return "/100x100bb.jpg"
            case .apiDateFormat: return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .convertedDateFormat: return "MMMM d, yyyy"
            case .convertedDateFormatShort: return "MMM d, yyyy"
            case .locale_US: return "en_US"
            case .colonSeperator: return " : "
            case .errorPromptDate: return "Invalid date string"
            case .errorPromptElementKind: return "Unexpected element kind"
            case .errorPromptKind: return "Unexpected kind"
            case .offlinePrompt: return "Turn on mobile data or connect to Wi-Fi"
            case .offLineAlertTitlePrompt: return "No internet connection"
            case .offLineActionTitlePrompt: return "Ok"
            case .loadingReusableName: return "PagingSpinnerReusableFooter"
            case .loadingReusableIdentifier: return "pagingspinnerreusablefooterid"
            case .headerReusableName: return "ReusableHeaderBar"
            case .headerReusableIdentifier: return "ReusableHeaderBarId"
            case .footerReusableName: return "ReusableFooterBar"
            case .footerReusableIdentifier: return "ReusableFooterBarId"
            case .fetchDataWithError: return "Error occured with fetchDataWith() - Cause: Decoding Error --> "
            case .fetchSingularDataError: return "Error occured with fetchSingularData() - Cause: Decoding Error --> "
            case .segmentedControlError : return "Error occured with segmentedControlValueChanged()"
            case .invalidJSON: return "Invalid JSON data"
        }
    }
}




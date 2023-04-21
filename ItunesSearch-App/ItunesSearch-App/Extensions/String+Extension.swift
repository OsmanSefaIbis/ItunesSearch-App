//
//  String+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 20.04.2023.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var withoutHtmlEntities: String {
        return htmlToAttributedString?.string ?? self
    }
}

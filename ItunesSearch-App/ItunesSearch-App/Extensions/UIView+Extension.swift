//
//  UIView+Extension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 5.05.2023.
//

import UIKit

extension UIView {
    
    func setAllTextColors(_ color: UIColor) {
        for subview in self.subviews {
            if let label = subview as? UILabel {
                label.textColor = color
            } else if let textField = subview as? UITextField {
                textField.textColor = color
            } else if let textView = subview as? UITextView {
                textView.textColor = color
            } else {
                subview.setAllTextColors(color)
            }
        }
    }
}

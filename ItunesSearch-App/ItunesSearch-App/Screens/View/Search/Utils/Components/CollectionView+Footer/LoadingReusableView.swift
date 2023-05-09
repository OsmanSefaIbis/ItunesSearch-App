//
//  LoadingReusableView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 26.04.2023.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = AppConstants.activityIndicatorColor
        activityIndicator.hidesWhenStopped = true
    }
    
}

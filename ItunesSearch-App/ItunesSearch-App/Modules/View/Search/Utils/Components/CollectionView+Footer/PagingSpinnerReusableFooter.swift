//
//  LoadingReusableView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 26.04.2023.
//

import UIKit

class PagingSpinnerReusableFooter: UICollectionReusableView {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.color = AppConstants.activityIndicatorColor
        spinner.hidesWhenStopped = true
    }
    
}

//
//  SearchCell.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 25.04.2023.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var trackPriceLabel: UILabel!
    @IBOutlet weak var cacheMissSpinner: UIActivityIndicatorView!
    
    var imageHeightConstraint, imageWidthConstraint : NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellLooks()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareReusability()
    }
}




//
//  SearchCell.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 14.04.2023.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var collectionPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

struct SearchCellModel {
    
    let artworkUrl: String
    let releaseDate: String
    let collectionName: String
    let collectionPrice: Double
}

//
//  SearchCell.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 14.04.2023.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var collectionPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellLooks()
    }
    
    func configureCell(with model: SearchCellModel) {
        
        artworkImage.kf.setImage(with: URL.init(string: model.artworkUrl))
        releaseDateLabel.text = convertData(for: model.releaseDate)
        collectionNameLabel.text = model.collectionName
        collectionPriceLabel.text = "$ ".appending(String(model.collectionPrice))
    }
    
    func configureCellLooks(){
        artworkImage.layer.cornerRadius = 10.0
        artworkImage.layer.masksToBounds = true
    }
}


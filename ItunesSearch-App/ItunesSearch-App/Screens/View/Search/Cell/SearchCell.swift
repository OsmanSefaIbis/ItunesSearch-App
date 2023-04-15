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
    }
    func configureCell(with model: SearchCellModel) {
        
        artworkImage.kf.setImage(with: URL.init(string: model.artworkUrl))
        // TODO: Date Conversion
        releaseDateLabel.text = convertData(for: model.releaseDate)
        collectionNameLabel.text = model.collectionName
        collectionPriceLabel.text = "$ ".appending(String(model.collectionPrice))
    }
}

struct SearchCellModel {
    
    let artworkUrl: String
    let releaseDate: String
    let collectionName: String
    let collectionPrice: Double
}

// TODO: Migrate this helper
func convertData(for dateValue: String) -> String{
    let inputDF = DateFormatter()
    inputDF.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    guard let inputDate = inputDF.date(from: dateValue) else {
        fatalError("Invalid date string")
    }
    let outputDF = DateFormatter()
    outputDF.dateFormat = "MMMM d, yyyy"
    let output = outputDF.string(from: inputDate)
    return output
}

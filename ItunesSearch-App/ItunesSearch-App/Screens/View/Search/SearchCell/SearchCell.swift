//
//  SearchCell.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 22.04.2023.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellLooks()
    }
    
    func configureCell(with model: SearchCellModel) {
        artworkImage.kf.setImage(with: URL(string: model.artworkUrl)) { result in
            switch result {
            case .success(let value):
                let averageColor = value.image.averageColor
                let opaqueAverageColor = averageColor?.withAlphaComponent(0.7)
                DispatchQueue.main.async { [weak self] in
                    self?.contentView.subviews.first?.backgroundColor = opaqueAverageColor
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        releaseDateLabel.text = convertDate(for: model.releaseDate)
        nameLabel.text = model.name
        collectionPriceLabel.text = HardCoded.dolar.get().appending(String(model.collectionPrice))
    }
    
    func configureCellLooks(){
        contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
        artworkImage.layer.cornerRadius = 10.0
        artworkImage.layer.masksToBounds = true
        artworkImage.kf.indicatorType = .activity
        (artworkImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
    }
}


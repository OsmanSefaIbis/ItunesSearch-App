//
//  SearchCell.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 25.04.2023.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionPriceLabel: UILabel!
    
    private let dimensionPreference = 200
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellLooks()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        artworkImage.image = nil
        releaseDateLabel.text = nil
        nameLabel.text = nil
        collectionPriceLabel.text = nil
    }
    
    func configureCell(with model: SearchCellModel) {
        
        guard let modifiedArtworkUrl =
                changeImageURL(model.artworkUrl, withDimension: dimensionPreference) else { return }
        
        artworkImage.kf.setImage(with: URL(string: modifiedArtworkUrl)){ result in
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
        (artworkImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = AppConstants.activityIndicatorColor
    }
}



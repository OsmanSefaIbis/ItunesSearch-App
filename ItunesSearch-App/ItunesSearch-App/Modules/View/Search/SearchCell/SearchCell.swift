//
//  SearchCell.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 25.04.2023.
//

import UIKit
import Kingfisher

// laterTODO: add interface for this class

class SearchCell: UICollectionViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var trackPriceLabel: UILabel!
    
    private var imageHeightConstraint, imageWidthConstraint : NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellLooks()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareReusability()
    }
    func prepareReusability() { // searchTODO: cell coloring is causing flickering effect because of cell reuse handle it for UX
        artworkImage.image = nil ; releaseDateLabel.text = nil ; nameLabel.text = nil ; trackPriceLabel.text = nil
    }
    func configureCellLooks() {
        contentView.layer.cornerRadius = 10.0 ; contentView.clipsToBounds = true
        artworkImage.layer.cornerRadius = 10.0 ; artworkImage.layer.masksToBounds = true
        artworkImage.kf.indicatorType = .activity
        (artworkImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = ConstantsApp.spinnerColor
        
        imageHeightConstraint = artworkImage.heightAnchor.constraint(equalToConstant: 0)
        imageWidthConstraint = artworkImage.widthAnchor.constraint(equalToConstant: 0)

        imageHeightConstraint?.isActive = true ; imageWidthConstraint?.isActive = true
        
    }
    func configureCell(with model: SearchCellModel) {

        guard let modifiedArtworkUrl = changeImageURL(model.artworkUrl, withDimension: ConstantsCV.dimensionPreference) else { return }

        releaseDateLabel.text = convertDate(for: model.releaseDate)
        nameLabel.text = model.name
        trackPriceLabel.text = (model.trackPrice <= 0) ? HardCoded.free.get() : HardCoded.dolar.get().appending(String(model.trackPrice))
        artworkImage.kf.setImage(with: URL(string: modifiedArtworkUrl)){ result in
            switch result {
            case .success(let value):
                let averageColor = value.image.averageColor
                let opaqueAverageColor = averageColor?.withAlphaComponent(0.7)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.container.backgroundColor = opaqueAverageColor
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func setImageHeigth( _ height: CGFloat) { // Setter for Constraints
        imageHeightConstraint?.constant = height
    }
    func setImageWidth( _ width: CGFloat) {
        imageWidthConstraint?.constant = width
    }
}



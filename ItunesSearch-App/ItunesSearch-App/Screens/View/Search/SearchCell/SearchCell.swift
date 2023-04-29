//
//  SearchCell.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 25.04.2023.
//

import UIKit
import Kingfisher

class SearchCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionPriceLabel: UILabel!
    @IBOutlet weak var vStackLabels: UIStackView!
    
    private let dimensionPreference = 200
    var imageHeigthConstraint: NSLayoutConstraint?
    var imageWidthConstraint: NSLayoutConstraint?
    var stackedLabelsHeightConstraint: NSLayoutConstraint?
    var stackedLabelsWidthConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellLooks()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
//        containerView.backgroundColor = nil
        artworkImage.image = nil
        releaseDateLabel.text = nil
        nameLabel.text = nil
        collectionPriceLabel.text = nil
    }

    func configureCell(with model: SearchCellModel) {

        guard let modifiedArtworkUrl = changeImageURL(model.artworkUrl, withDimension: dimensionPreference) else { return }

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
        
        imageHeigthConstraint = artworkImage.heightAnchor.constraint(equalToConstant: 0)
        imageWidthConstraint = artworkImage.widthAnchor.constraint(equalToConstant: 0)
        stackedLabelsHeightConstraint = vStackLabels.heightAnchor.constraint(equalToConstant: 0)
        stackedLabelsWidthConstraint = vStackLabels.widthAnchor.constraint(equalToConstant: 0)
        
        imageHeigthConstraint?.isActive = true
        imageWidthConstraint?.isActive = true
        stackedLabelsHeightConstraint?.isActive = true
        stackedLabelsWidthConstraint?.isActive = true
    }
    // Setter for Constraints
    func setImageHeigth( _ height: CGFloat){
        imageHeigthConstraint?.constant = height
    }
    func setImageWidth( _ width: CGFloat){
        imageWidthConstraint?.constant = width
    }
    func setStackedLabelsHeigth( _ height: CGFloat){
        stackedLabelsHeightConstraint?.constant = height
    }
    func setStackedLabelsWidth( _ width: CGFloat){
        stackedLabelsWidthConstraint?.constant = width
    }
}



//
//  SearchCell+SearchCellContract.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 31.05.2023.
//

import UIKit

extension SearchCell: SearchCellContract {
    
    func prepareReusability() {
            artworkImage.image = nil ; releaseDateLabel.text = nil ; nameLabel.text = nil ; trackPriceLabel.text = nil; container.backgroundColor = .lightGray
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
    
    func configureCell(with model: SearchCellModel, size constraint: CGFloat) {
        
        self.setImageHeigth( 2 * constraint ) ; self.setImageWidth( 2 * constraint )
        
        guard let modifiedArtworkUrl = changeImageURL(model.artworkUrl, withDimension: ConstantsCV.cellImageDimension) else { return }
        
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
    
    func startSpinner() {
        DispatchQueue.main.async { [weak self] in
            self?.cacheMissSpinner.startAnimating()
        }
    }
    
    func stopSpinner() {
        DispatchQueue.main.async { [weak self] in
            self?.cacheMissSpinner.stopAnimating()
        }
    }
    
    func setImageHeigth( _ height: CGFloat) {
        imageHeightConstraint?.constant = height
    }
    
    func setImageWidth( _ width: CGFloat) {
        imageWidthConstraint?.constant = width
    }
}

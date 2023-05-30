//
//  HeaderReusableView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 4.05.2023.
//

import UIKit

class ReusableHeaderBar: UICollectionReusableView {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerView.layer.cornerRadius = 8.0
        headerView.layer.masksToBounds = true
    }
    
    func setTitleForTop(with media: String){
        DispatchQueue.main.async { [weak self] in
            self?.headerTitle.text = media.appending(HardCoded.collectionViewHeaderTopPicksPhrase.get())
        }
    }
    func setTitleForNoResults(){
        DispatchQueue.main.async { [weak self] in
            self?.headerTitle.text = HardCoded.collectionViewHeaderNoResultsPhrase.get()
        }
    }
}

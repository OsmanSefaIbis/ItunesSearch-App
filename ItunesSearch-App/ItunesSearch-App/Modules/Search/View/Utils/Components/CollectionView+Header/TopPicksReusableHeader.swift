//
//  HeaderReusableView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 4.05.2023.
//

import UIKit

class TopPicksReusableHeader: UICollectionReusableView {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerView.layer.cornerRadius = 8.0
        headerView.layer.masksToBounds = true
    }
    
    func setTitleForTop(with media: String){
        headerTitle.text = media.appending(HardCoded.collectionViewHeaderPhrase.get())
    }
    func setTitleForNoResults(){
        headerTitle.text = HardCoded.collectionViewHeaderNoResultsPhrase.get()
    }
}

//
//  HeaderReusableView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 4.05.2023.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerView.layer.cornerRadius = 8.0
         headerView.layer.masksToBounds = true
    }
    
    func setTitle(with categoryType: String){
        headerTitle.text = categoryType.appending(HardCoded.collectionViewHeaderPhrase.get())
    }
}

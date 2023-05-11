//
//  HeaderReusableView.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 4.05.2023.
//

import UIKit
//TODO: Naming change
class HeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerView.layer.cornerRadius = 8.0
         headerView.layer.masksToBounds = true
    }
    
    func setTitle(with MediaTypeType: String){
        headerTitle.text = MediaTypeType.appending(HardCoded.collectionViewHeaderPhrase.get())
    }
}

//
//  ReusableFooterBar.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 30.05.2023.
//

import UIKit

class ReusableFooterBar: UICollectionReusableView {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        footerView.layer.cornerRadius = 8.0
        footerView.layer.masksToBounds = true
    }

    func setTitle(for totalCount: Int){
        DispatchQueue.main.async { [weak self] in
            self?.footerTitle.text = String(totalCount)
                .appending(HardCoded.collectionViewFooterPhrase.get())
        }
    }
}

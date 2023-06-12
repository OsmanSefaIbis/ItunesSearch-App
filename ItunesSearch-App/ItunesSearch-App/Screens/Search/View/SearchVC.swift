//
//  ViewController.swift
//  ItunesSearch-App
//

import UIKit

final class SearchVC: UIViewController{
    
    @IBOutlet weak var spinnerCollectionView: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
        
    lazy var searchViewModel = SearchVM(view: self)
    lazy var detailViewModel = DetailVM()
    
    var pagingSpinner: PagingSpinnerReusableFooter?
    var headerBar: ReusableHeaderBar?
    var footerBar: ReusableFooterBar?
    var sizingValue: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewModel.viewDidLoad()
    }
}

//
//  ViewController.swift
//  ItunesSearch-App
//

import UIKit

class SearchView: UIViewController{
    
    // Soft Coded Stuff
    typealias RowItems = SearchCellModel
    private let cellIdentifier = "SearchCell"
    // UIComponents
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let viewModel = SearchViewModel()   // VM Instance
    private var items: [RowItems] = []          // Cell Info
    private var categorySelection = Category.movie
    
    // VLC
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initiating()
    }
    func initiating(){
        configureCollectionView()
        assignDelegates()
        configureSegmentedControl()
    }
    
    func assignDelegates(){
        viewModel.delegate = self
        searchBar.delegate = self
    }
    func configureCollectionView(){
        collectionView?.register( .init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    func configureSegmentedControl(){
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    func setItems( _ items: [RowItems]) {
        
        self.items = items
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0:
                categorySelection = Category.movie
            case 1:
                categorySelection = Category.music
            case 2:
                categorySelection = Category.ebook
            case 3:
                categorySelection = Category.podcast
        default:
            fatalError("Error occured with segmentedControlValueChanged()")
        }
    }

} /// EOC

/*
//
//
//  Readability Seperator For ME
//
//
*/

// MARK: Extensions

/************************   CollectionView  ************************/
/// DataSource
extension SearchView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SearchCell
        cell.configureCell(with: items[indexPath.row])
        return cell
    }
}
/// Delegate
extension SearchView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Go to detail
    }
}
/// FlowLayout
extension SearchView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let availableWidth = collectionView.bounds.width - 20
            let itemWidth = (availableWidth / 2).rounded(.down)
            let itemHeight = 30.0
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
}
/************************   SearchBar  ************************/
extension SearchView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchInvoked(searchBar.text!, categorySelection.rawValue)
    }
}

/************************   ViewModel  ************************/
extension SearchView: SearchViewModelDelegate {
    
    func refreshItems(_ retrived: [SearchCellModel]) {
        setItems(retrived)
    }
}











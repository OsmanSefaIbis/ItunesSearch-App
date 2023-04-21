//
//  ViewController.swift
//  ItunesSearch-App
//

import UIKit

class SearchView: UIViewController{
    
    typealias RowItems = SearchCellModel
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var items: [RowItems] = []
    private let viewModel = SearchViewModel()
    private var paginationOffSet = 0
    private var endOfRecordsFlag = false
    private var idsOfAllFetchedRecords = Set<Int>()
    private var categorySelection: Category?
    private var timeControl: Timer?
    private let cellIdentifier = HardCoded.cellIdentifier.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiating()
    }
    
    func initiating() {
        configureCollectionView()
        assignDelegates()
        configureSegmentedControl()
    }
    
    func assignDelegates() {
        viewModel.delegate = self
        searchBar.delegate = self
    }
    
    func configureCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(
            .init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func setItems( _ items: [RowItems]) {
        if items.count != requestLimit { endOfRecordsFlag = true }
        if endOfRecordsFlag {
            var lastRecords: [RowItems] = []
            for each in items {
                if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue }
                else { lastRecords.append(each) }
            }
            self.items.append(contentsOf: lastRecords)
            idsOfAllFetchedRecords.removeAll()
        }else {
            if paginationOffSet != 0 {
                for each in items { idsOfAllFetchedRecords.insert(each.id) }
                self.items.append(contentsOf: items)
            }else {
                for each in items { idsOfAllFetchedRecords.insert(each.id) }
                self.items = items
            }
        }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView?.reloadData()
        }
    }
    
    func configureSegmentedControl() {
        segmentedControl.addTarget(
            self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0: categorySelection = Category.movie
            case 1: categorySelection = Category.music
            case 2: categorySelection = Category.ebook
            case 3: categorySelection = Category.podcast
        default: fatalError("Error occured with segmentedControlValueChanged()")
        }
    }
}

// MARK: Extensions

/* ViewModel - Delegate */
extension SearchView: SearchViewModelDelegate {
    
    func refreshItems(_ retrived: [SearchCellModel]) {
        setItems(retrived)
    }
}

/* CollectionView - Data */
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

/* CollectionView - Delegate */
extension SearchView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        switch categorySelection {
            
        case .movie:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.movie.rawValue) as? DetailView{
                embedViewControllerWithId(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .music:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.music.rawValue) as? DetailView{
                embedViewControllerWithId(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .ebook:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.ebook.rawValue) as? DetailView{
                embedViewControllerWithId(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .podcast:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.podcast.rawValue) as? DetailView{
                embedViewControllerWithId(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        default:
            return
        }
        func embedViewControllerWithId(_ vc: inout DetailView) {
            
            let searchEntity = items[indexPath.item]
            let searchId = searchEntity.id
            vc.id = searchId
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if endOfRecordsFlag{
            return
        }
        let latestItemNumeric = items.count - 1
        if indexPath.item == latestItemNumeric {
            
            guard let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            guard let category = categorySelection else { return }
            paginationOffSet += requestLimit
            self.viewModel.searchInvoked(searchText, category, paginationOffSet)
        }
    }
}

/* CollectionView - Flow */
extension SearchView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let availableWidth = collectionView.bounds.width
            let itemWidth = (availableWidth / 2).rounded(.down)
            let itemHeight = 100.0
            return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
}

/* SearchBar - Delegate */
extension SearchView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let category = categorySelection else { return }
    
        paginationOffSet = 0
        endOfRecordsFlag = false
        viewModel.searchInvoked(searchText, category, paginationOffSet)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timeControl?.invalidate()
        timeControl = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            
            guard let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            
            if (0...2).contains(searchText.count){
                self?.activityIndicator.stopAnimating()
            }
            if searchText.count == 0 {
                DispatchQueue.main.async {
                    self?.items.removeAll()
                    self?.collectionView.reloadData()
                }
            }else if searchText.count > 2 {
                guard let category = self?.categorySelection else { return }
                guard let offSet = self?.paginationOffSet else { return }
                self?.paginationOffSet = 0
                self?.endOfRecordsFlag = false
                self?.activityIndicator.startAnimating()
                self?.viewModel.searchInvoked(searchText, category, offSet)
            }
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        self.items.removeAll()
        self.collectionView.reloadData()
    }
}











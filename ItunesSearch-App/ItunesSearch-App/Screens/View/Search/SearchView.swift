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
    private let requestLimit = 20
    private let collectionViewColumn: CGFloat = 2
    private var lessThanPage_Flag = false
    private var idsOfAllFetchedRecords = Set<Int>()
    private var categorySelection: Category? = .movie
    private var timeControl: Timer?
    private let cellIdentifier = HardCoded.cellIdentifier.get()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiating()
    }
    
    func initiating() {
        configureCollectionView()
        assignDelegates()
        configureSegmentedControl()
        configureGesture()
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
        // incoming data -> items
    
        if items.count != requestLimit { lessThanPage_Flag = true } // decision point

        if lessThanPage_Flag { // less than a page
            if self.items.count >= requestLimit { /// case: last page with less than request limit
                var lastRecords: [RowItems] = []
                /// NOTE: API sends as the requestLimit, records can overlap at the end, so extract only the required
                for each in items {
                    if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue } // skip
                    else { lastRecords.append(each) } // track
                }
                self.items.append(contentsOf: lastRecords) // add track
                //idsOfAllFetchedRecords.removeAll()
            } else { /// case: first page with less than request limit
                self.items = items
            }
        } else { /// each page
            if paginationOffSet == 0 { /// first full page
                for each in items { idsOfAllFetchedRecords.insert(each.id) }
                self.items = items
            }else { /// next page
                for each in items { idsOfAllFetchedRecords.insert(each.id) }
                self.items.append(contentsOf: items)
            }
        }
        /// render
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView?.reloadData()
        }
    }
    
    func configureGesture(){
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func configureSegmentedControl() {
        segmentedControl.addTarget(
            self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        switch sender.selectedSegmentIndex {
            case 0: categorySelection = Category.movie
                if searchText.count > 2 {
                    resetAndSearch(searchText, Category.movie, nil)
                }
            case 1: categorySelection = Category.music
                if searchText.count > 2 {
                    resetAndSearch(searchText, Category.music, nil)
                }
            case 2: categorySelection = Category.ebook
                if searchText.count > 2 {
                    resetAndSearch(searchText, Category.ebook, nil)
                }
            case 3: categorySelection = Category.podcast
                if searchText.count > 2 {
                    resetAndSearch(searchText, Category.podcast, nil)
                }
        default: fatalError(HardCoded.segmentedControlError.get())
        }
    }
    func resetAndSearch(_ searchTerm: String, _ category: Category, _ offSetValue: Int?){
        
        idsOfAllFetchedRecords.removeAll() ///  dealloc

        paginationOffSet = 0
        lessThanPage_Flag = false
        
        if items.count > 0{
            reset()
        }
        activityIndicator.startAnimating()
        if let offSet = offSetValue{
            viewModel.searchInvoked(searchTerm, category, offSet)
        }else{
            viewModel.searchInvoked(searchTerm, category, paginationOffSet)
        }
    }
    func reset(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.items.removeAll()
            self.collectionView.reloadData()
        }
    }
}

// MARK: Extensions

/* ViewModel - Delegate */
extension SearchView: SearchViewModelDelegate {
    
    func refreshItems(_ retrived: [SearchCellModel]) {
        setItems(retrived)
    }
    
    func internetUnreachable(_ errorPrompt: String) {
        let alertController = UIAlertController(title: "Warning", message: errorPrompt, preferredStyle: .alert )
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action:UIAlertAction!) in
            self?.reset()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
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
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.movie.get()) as? DetailView{
                embedViewControllerWithId(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .music:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.music.get()) as? DetailView{
                embedViewControllerWithId(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .ebook:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.ebook.get()) as? DetailView{
                embedViewControllerWithId(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .podcast:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.podcast.get()) as? DetailView{
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
        
        if lessThanPage_Flag{
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        let cellSpacing: CGFloat = 5;
        let cellWidth: CGFloat = 160.0;
        var inset: CGFloat = (collectionView.bounds.size.width - (collectionViewColumn * cellWidth) - ((collectionViewColumn - 1)*cellSpacing)) * 0.5;
        inset = max(inset, 0.0);
        return UIEdgeInsets(top: 0, left: inset/collectionViewColumn, bottom: 0, right: inset/collectionViewColumn)
    }
}

/* SearchBar - Delegate */
extension SearchView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        if (0...2).contains(searchText.count) {
            reset()
        }else {
            guard let category = categorySelection else { return }
            self.resetAndSearch(searchText, category, paginationOffSet)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timeControl?.invalidate()
        timeControl = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [weak self] (timer) in
            
            guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            
            if (0...2).contains(searchText.count){
                self?.activityIndicator.stopAnimating()
            }
            if searchText.isEmpty {
                self?.reset()
                return
            }
            if searchText.count > 2 {
                guard let category = self?.categorySelection else { return }
                guard let offSet = self?.paginationOffSet else { return }
                self?.resetAndSearch(searchText, category, offSet)
            }
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        reset()
    }
}











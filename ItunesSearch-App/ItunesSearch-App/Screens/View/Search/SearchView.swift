//
//  ViewController.swift
//  ItunesSearch-App
//

import UIKit
import Kingfisher

class SearchView: UIViewController{
    
    typealias RowItems = SearchCellModel
    private let cellIdentifier = HardCoded.cellIdentifier.get()
    
    @IBOutlet private weak var activityIndicatorOverall: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var items: [RowItems] = []
    private let viewModel = SearchViewModel()
    private var detailViewModel = DetailViewModel()
    private var idsOfAllFetchedRecords = Set<Int>()
    private var timeControl: Timer?
    
    private var paginationOffSet = 0
    private var lessThanPage_Flag = false
    private var isLoadingNextPage = false
    private var categorySelection: Category? = .movie
    private var loadingView: LoadingReusableView?
    private var cacheDetails: [Int : Detail] = [:]
    private let imageDimensionForDetail = 600
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiating()
    }
    
    func initiating() {
        configureCollectionView()
        assignDelegates()
        configureSegmentedControl()
        configureGesture()
        configureActivityIndicator()

    }
    
    func assignDelegates() {
        viewModel.delegate = self
        searchBar.delegate = self
        detailViewModel.delegate = self
    }
    
    func configureCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(
            .init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        collectionView?.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
        collectionView.isPrefetchingEnabled = true
    }
    
    func setItems( _ items: [RowItems]) {
        /// NOTE: API does not support pagination via json, offset and limit used
        /// self.items <- existing data  incoming data -> items
    
        if items.count != AppConstants.requestLimit { lessThanPage_Flag = true } /// decision point (true == do not fetch more)

        if lessThanPage_Flag { /// less than a page
            if self.items.count >= AppConstants.requestLimit  { /// case: last page with less than request limit
                var lastRecords: [RowItems] = []
                /// NOTE: API sends as the requestLimit, records can overlap at the end, so extract only the required
                for each in items {
                    if idsOfAllFetchedRecords.contains(where: { $0 == each.id }) { continue } /// skip
                    else { lastRecords.append(each) } /// track
                }
                self.items.append(contentsOf: lastRecords) /// add track
                idsOfAllFetchedRecords.removeAll() /// dealloc track
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
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(400)) {
            DispatchQueue.main.async {
                self.activityIndicatorOverall.stopAnimating()
                self.collectionView?.reloadData()
                self.isLoadingNextPage = false
            }
        }
        
    }
    
    func startPrefetchingDetails(for ids: [Int]){
        detailViewModel.searchInvoked(withIds: ids)
    }
    
    func configureActivityIndicator(){
        activityIndicatorOverall.color = AppConstants.activityIndicatorColor
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
        cacheDetails.removeAll() /// dealloc
        paginationOffSet = 0
        lessThanPage_Flag = false
        
        if items.count > 0 {
            reset()
        }
        DispatchQueue.main.async {
            self.activityIndicatorOverall.startAnimating()
        }
        if let offSet = offSetValue{
            viewModel.searchInvoked(searchTerm, category, offSet)
        }else{
            viewModel.searchInvoked(searchTerm, category, paginationOffSet)
        }
    }
    func reset(){
        idsOfAllFetchedRecords.removeAll() ///  dealloc
        cacheDetails.removeAll() /// dealloc
        
        DispatchQueue.main.async {
            self.activityIndicatorOverall.stopAnimating()
            self.items.removeAll()
            self.collectionView.reloadData()
        }
    }
    func providesIds(_ items: [SearchCellModel]) -> [Int] {
        var holdsIds: [Int] = []
        for each in items{
            holdsIds.append(each.id)
        }
        return holdsIds
    }
}

// MARK: Extensions
/* ViewModel - Delegate */
extension SearchView: SearchViewModelDelegate {
    
    func refreshItems(_ retrived: [SearchCellModel]) {
        setItems(retrived)
        startPrefetchingDetails(for: providesIds(retrived))
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
extension SearchView: DetailViewModelDelegate{
    func refreshItem(_ retrieved: [Detail]) {
        for each in retrieved{
            cacheDetails[each.id] = each
        }
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
                embedViewControllerWithCached(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .music:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.music.get()) as? DetailView{
                embedViewControllerWithCached(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .ebook:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.ebook.get()) as? DetailView{
                embedViewControllerWithCached(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        case .podcast:
            if var detailPage =  storyboard?.instantiateViewController(withIdentifier: CategoryView.podcast.get()) as? DetailView{
                embedViewControllerWithCached(&detailPage)
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
        default:
            return
        }
        func embedViewControllerWithCached(_ vc: inout DetailView) {
            let currentItem = items[indexPath.item]
            let detailId = currentItem.id
            guard let detailData = cacheDetails[detailId] else { return }
            provideImageAndColor(currentItem.artworkUrl) { [weak vc] imageAndColor in
                guard let detailTuple = imageAndColor else { return }
                DispatchQueue.main.async { [weak vc] in
                    vc?.id = detailId
                    vc?.configureItem(with: detailData, image: detailTuple.artwork, color: detailTuple.colorAverage)
                }
            }
        }
        
        func provideImageAndColor(_ imageUrl: String, completion: @escaping ((artwork: UIImage, colorAverage: UIColor)?) -> Void) {
            guard let modifiedArtworkUrl = changeImageURL(imageUrl, dimension: imageDimensionForDetail) else {
                completion(nil)
                return
            }
            KingfisherManager.shared.retrieveImage(with: URL(string: modifiedArtworkUrl)!) { result in
                switch result {
                case .success(let value):
                    guard let color = value.image.averageColor else {
                        completion(nil)
                        return
                    }
                    completion((value.image, color))
                case .failure(_):
                    completion(nil)
                }
            }
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
            paginationOffSet += AppConstants.requestLimit
            isLoadingNextPage = true
            self.viewModel.searchInvoked(searchText, category, paginationOffSet)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoadingNextPage {
                    return CGSize.zero
                } else {
                    return CGSize(width: collectionView.bounds.size.width, height: 40)
                }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionFooter {
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
                loadingView = aFooterView
                loadingView?.backgroundColor = UIColor.clear
                return aFooterView
            }
            return UICollectionReusableView()
        }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
            if elementKind == UICollectionView.elementKindSectionFooter && isLoadingNextPage {
                self.loadingView?.activityIndicator.startAnimating()
            }
        }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
}

/* CollectionView - Flow */
extension SearchView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
        let cellSpacing: CGFloat = 5;
        let cellWidth: CGFloat = 160.0;
        var inset: CGFloat = (collectionView.bounds.size.width -
                               (AppConstants.collectionViewColumn * cellWidth) -
                               ((AppConstants.collectionViewColumn - 1)*cellSpacing)) * 0.5
        inset = max(inset, 0.0);
        return UIEdgeInsets(top: 0, left: inset/AppConstants.collectionViewColumn, bottom: 0, right: inset/AppConstants.collectionViewColumn)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
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
            paginationOffSet = 0
            guard let category = categorySelection else { return }
            self.resetAndSearch(searchText, category, paginationOffSet)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timeControl?.invalidate()
        timeControl = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [weak self] (timer) in
            
            guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            
            if (0...2).contains(searchText.count){
                self?.activityIndicatorOverall.stopAnimating()
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













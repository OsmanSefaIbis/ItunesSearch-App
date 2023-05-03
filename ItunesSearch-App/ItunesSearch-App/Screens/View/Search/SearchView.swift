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
    private let searchViewModel = SearchViewModel()
    private var detailViewModel = DetailViewModel()
    private var idsOfAllFetchedRecords = Set<Int>()
    private var timeControl: Timer?
    
    private var paginationOffSet = 0
    private var lessThanPage_Flag = false
    private var isLoadingNextPage = false
    private var categorySelection: Category? = .movie
    private var loadingView: LoadingReusableView?
    private var cacheDetails: [Int : Detail] = [:]
    private var cacheDetailImagesAndColors: [Int : (UIImage, UIColor)] = [:]
    private let imageDimensionForDetail = 600
    private let defaultCellSize = CGSize(width: 160, height: 80)
    private var sizingValue: CGFloat = 80.0
    private var defaultMinimumCellSpacing = 10.0
    private var collectionViewColumnCount: Int = 2
    private let defaultSectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
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
        searchViewModel.delegate = self
        detailViewModel.delegate = self
        searchBar.delegate = self
    }
    
    func configureCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(
            .init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        collectionView?.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
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
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(400)) { // TODO: GET RID OF THIS LINE, OPTIMIZE !!!
            DispatchQueue.main.async {
                self.activityIndicatorOverall.stopAnimating()
                self.collectionView?.reloadData()
                self.isLoadingNextPage = false
            }
        }
    }
    func setRandomItems( _ items: [RowItems]) {
        
        for each in items { idsOfAllFetchedRecords.insert(each.id) }
        self.items.append(contentsOf: items)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(400)) { // TODO: GET RID OF THIS LINE, OPTIMIZE !!!
            DispatchQueue.main.async {
                self.activityIndicatorOverall.stopAnimating()
                self.collectionView?.reloadData()
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
                guard let averagedColor = value.image.averageColor else {
                    completion(nil)
                    return
                }
                completion((value.image, averagedColor))
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func startPrefetchingDetails(for ids: [Int]){
        detailViewModel.searchInvoked(withIds: ids)
    }
    
    func startPrefetchingDetailsForRandom(for ids: [Int]){
        detailViewModel.randomInvoked(withIds: ids)
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
                } else {
                    resetAndDiscover(Category.movie, self.randomizeOffset())
                }
            case 1: categorySelection = Category.music
                if searchText.count > 2 {
                    resetAndSearch(searchText, Category.music, nil)
                } else {
                    resetAndDiscover(Category.music, self.randomizeOffset())
                }
            case 2: categorySelection = Category.ebook
                if searchText.count > 2 {
                    resetAndSearch(searchText, Category.ebook, nil)
                } else {
                    resetAndDiscover(Category.ebook, self.randomizeOffset())
                }
            case 3: categorySelection = Category.podcast
                if searchText.count > 2 {
                    resetAndSearch(searchText, Category.podcast, nil)
                } else {
                    resetAndDiscover(Category.podcast, self.randomizeOffset())
                }
        default: fatalError(HardCoded.segmentedControlError.get())
        }
    }
    func resetAndSearch(_ searchTerm: String, _ category: Category, _ offSetValue: Int?){
        resetCollections() /// dealloc
        paginationOffSet = 0
        lessThanPage_Flag = false
        
        if items.count > 0 {
            reset()
        }
        DispatchQueue.main.async {
            self.activityIndicatorOverall.startAnimating()
        }
        if let offSet = offSetValue{
            searchViewModel.searchInvoked(searchTerm, category, offSet)
        }else{
            searchViewModel.searchInvoked(searchTerm, category, paginationOffSet)
        }
    }
    func resetAndDiscover(_ category: Category, _ offSetValue: Int){
        reset()
        self.discoveryInvoke(category, offSetValue)
    }
    
    func discoveryInvoke(_ category: Category, _ offSetValue: Int){
        DispatchQueue.main.async {
            self.activityIndicatorOverall.startAnimating()
        }
        searchViewModel.randomInvoked(category, offSetValue)
    }
    
    func reset(){
        resetCollections() /// dealloc
        DispatchQueue.main.async {
            self.activityIndicatorOverall.stopAnimating()
            self.items.removeAll()
            self.collectionView.reloadData()
        }
    }
    
    func resetCollections(){
        idsOfAllFetchedRecords.removeAll()
        cacheDetails.removeAll()
        cacheDetailImagesAndColors.removeAll()
    }
    
    func providesIds(_ items: [SearchCellModel]) -> [Int] {
        var holdsIds: [Int] = []
        for each in items{
            holdsIds.append(each.id)
        }
        return holdsIds
    }
    
    func randomizeOffset() -> Int{
        Int.random(in: 0 ..< 3000) // upperLimit is unknown, discovery is limited by this value
    }
}

// MARK: Extensions
/* ViewModel - Delegates */
extension SearchView: SearchViewModelDelegate {
    
    func refreshItems(_ retrived: [SearchCellModel]) {
        setItems(retrived)
        startPrefetchingDetails(for: providesIds(retrived))
    }
    
    func refreshRandomItems(_ retrieved: [SearchCellModel]) {
        setRandomItems(retrieved)
        startPrefetchingDetailsForRandom(for: providesIds(retrieved))
        
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
            provideImageAndColor( each.artworkUrl) { [weak self] imageAndColor in
                guard let detailTuple = imageAndColor else { return }
                self?.cacheDetailImagesAndColors[each.id] = detailTuple
            }
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
        cell.setImageHeigth( 2 * sizingValue )
        cell.setImageWidth( 2 * sizingValue )
        cell.setStackedLabelsHeigth( 2 * sizingValue )
        cell.setStackedLabelsWidth( 3 * sizingValue )
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
            guard let detailImageAndColor = cacheDetailImagesAndColors[detailId] else { return }
            
            DispatchQueue.main.async { [weak vc] in
                vc?.id = detailId
                vc?.configureItem(with: detailData, image: detailImageAndColor.0, color: detailImageAndColor.1)
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
            if (0...2).contains(searchBar.text!.count){
                self.searchViewModel.randomInvoked(category, self.randomizeOffset())
            }else{
                self.searchViewModel.searchInvoked(searchText, category, paginationOffSet)
            }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // SearchView+Pseudo --> Inludes the pseudocode of below logic
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return defaultCellSize }
        let totalWidth = collectionView.bounds.width
        let sectionInsets = flowLayout.sectionInset
        /* FIXME: NOT URGENT
                - Decreasing the multiplier causes one column
                - Increasing the multiplier causes the last item in the grid to clip to left item
                - But when user wants more data the last cell orients back to alignment
         */
        let cellSpacingMin = ( (1.4) * (flowLayout.minimumInteritemSpacing) ) // band aid solution
        let totalInsetSpace = (CGFloat(collectionViewColumnCount)  * ( sectionInsets.left + sectionInsets.right ))
        let availableWidthForCells = (totalWidth - cellSpacingMin - totalInsetSpace)
        sizingValue =  ( availableWidthForCells / CGFloat(collectionViewColumnCount) ) / 5
        let cellWidth = sizingValue * 5
        let cellHeight = sizingValue * 2
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        return cellSize
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return defaultSectionInset }
        flowLayout.sectionInset = defaultSectionInset
        return flowLayout.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return defaultMinimumCellSpacing }
        flowLayout.minimumInteritemSpacing = defaultMinimumCellSpacing
        return flowLayout.minimumInteritemSpacing
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
            if (1...20).contains(items.count)  {
                searchBar.resignFirstResponder()
            }else{
                paginationOffSet = 0
                guard let category = categorySelection else { return }
                self.resetAndSearch(searchText, category, paginationOffSet)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timeControl?.invalidate()
        timeControl = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [weak self] (timer) in
            
            guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            guard let category = self?.categorySelection else { return }

            if (0...2).contains(searchText.count){
                if let offset = self?.randomizeOffset(){
                    self?.discoveryInvoke(category, offset)
                }
            }
            if searchText.count > 2 {
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














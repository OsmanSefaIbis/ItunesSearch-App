//
//  ViewController.swift
//  ItunesSearch-App
//

import UIKit
import Kingfisher

protocol SearchViewInterface: AnyObject {
    
    // assign specific
    func assignPropsOfSearchViewModel()
    func assignPropsOfDetailViewModel()
    func assignPropsOfSearchBar()
    
    // configure specific
    func configureCollectionView()
    func configureSegmentedControl()
    func configureActivityIndicator()
    
    // operation specific
    func initiateTopResults()
    func startPrefetchingDetails(for ids: [Int])
    func setItems( _ items: [RowItems])
    func invokeTopIds( _ topIds: [Top])
    
    // data specific
    func reset()
    func resetAndSearch(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int?)
    func resetAndTrend(_ mediaType: MediaType)
    
    // UI specific
    func stopActivityIndicator()
    func startActivityIndicator()
    func reloadCollectionView()
    
}

final class SearchView: UIViewController{
    
    typealias RowItems = SearchCellModel
    private let cellIdentifier = HardCoded.cellIdentifier.get()
    
    let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
    let hapticSoft = UIImpactFeedbackGenerator(style: .soft)
    
    @IBOutlet private weak var activityIndicatorOverall: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var items: [RowItems] = []
    

    private lazy var  searchViewModel = SearchViewModel()
    private var detailViewModel = DetailViewModel()
    
    
    private var idsOfAllFetchedRecords = Set<Int>()
    private var timeControl: Timer?
    
    private var lessThanPage_Flag = false
    private var isLoadingNextPage_Flag = false
    private var isSearchActive_Flag = false
    private var mediaType_State: MediaType? = .movie
    
    private var loadingView: LoadingReusableView?
    private var headerView: HeaderReusableView?
    private var cacheDetails: [Int : Detail] = [:]
    private var cacheDetailImagesAndColors: [Int : (UIImage, UIColor)] = [:]
    private var paginationOffSet = 0
    private let imageDimensionForDetail = 600
    private let defaultCellSize = CGSize(width: 160, height: 80)
    private var sizingValue: CGFloat = 80.0
    private var defaultMinimumCellSpacing = 10.0
    private var collectionViewColumnCount: Int = 2
    private let defaultSectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewModel.viewDidLoad()
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
    
    func providesIds(_ items: [SearchCellModel]) -> [Int] {
        var holdsIds: [Int] = []
        for each in items{
            holdsIds.append(each.id)
        }
        return holdsIds
    }
    

}

// MARK: Extensions

extension SearchView: SearchViewInterface {

    // assign specific
    func assignPropsOfSearchViewModel(){
        searchViewModel.view = self
        searchViewModel.delegate = self
    }
    func assignPropsOfDetailViewModel(){
        detailViewModel.delegate = self
    }
    func assignPropsOfSearchBar(){
        searchBar.delegate = self
    }
    // configure specific
    func configureCollectionView() {
        assignPropsOfCollectionView()
        registersOfCollectionView()
    }
    func configureSegmentedControl() {
        segmentedControl.addTarget(
            self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    func configureActivityIndicator() {
        activityIndicatorOverall.color = AppConstants.activityIndicatorColor
    }
    // operation specific
    func initiateTopResults() {
        startActivityIndicator()
        guard let MediaType = mediaType_State else { return }
        searchViewModel.topInvoked(MediaType)
    }
    func startPrefetchingDetails(for ids: [Int]) {
        detailViewModel.searchInvoked(withIds: ids)
    }
    func setItems( _ items: [SearchCellModel]) {
        searchViewModel.setItems(items)
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(400)) {
            self.stopActivityIndicator()
            self.reloadCollectionView()
            self.isLoadingNextPage_Flag = false // ?????
        }
    }
    func invokeTopIds( _ topIds: [Top]) {
        var holdsTopIds: [String] = []
        for each in topIds{
            holdsTopIds.append(each.id)
        }
        searchViewModel.topWithIdsInvoked(holdsTopIds)
    }
    
    // data specific
    func reset() {
        searchViewModel.reset()
    }
    func resetAndSearch(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int?){
        searchViewModel.resetAndSearch(searchTerm, mediaType, offSetValue)
    }
    func resetAndTrend(_ mediaType: MediaType) {
        searchViewModel.resetAndTrend(mediaType)
    }
    
    // UISpecific
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorOverall.stopAnimating()
        }
    }
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorOverall.startAnimating()
        }
    }
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // Helpers
    func assignPropsOfCollectionView(){
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    func registersOfCollectionView(){
        let loadingReusableNib = UINib(nibName: HardCoded.loadingReusableName.get(), bundle: nil)
        let headerReusableNib = UINib(nibName: HardCoded.headerReusableName.get(), bundle: nil)
        collectionView?.register(.init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.register(loadingReusableNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: HardCoded.loadingReusableIdentifier.get())
        collectionView?.register(headerReusableNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HardCoded.headerReusableIdentifier.get())
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        hapticFeedbackSoft()
        guard let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let indexValue = sender.selectedSegmentIndex
        searchViewModel.segmentedControlValueChanged(to: indexValue, with: searchText)
    }
}



/* ViewModel - Delegates */
extension SearchView: SearchViewModelDelegate {

    func refreshItems(_ retrieved: [SearchCellModel]) {
        setItems(retrieved)
        startPrefetchingDetails(for: providesIds(retrieved))
    }
    func topItems(_ retrieved: [Top]) {
        invokeTopIds(retrieved)
    }
    func internetUnreachable(_ errorPrompt: String) {
        let alertController = UIAlertController(title: HardCoded.offLineAlertTitlePrompt.get(), message: errorPrompt, preferredStyle: .alert )
        let okAction = UIAlertAction(title: HardCoded.offLineActionTitlePrompt.get(), style: .default) { [weak self] (action:UIAlertAction!) in
            self?.searchViewModel.reset()
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
        hapticFeedbackHeavy()
        collectionView.deselectItem(at: indexPath, animated: true)
        switch mediaType_State {
            case .movie:
                if var detailPage =  storyboard?.instantiateViewController(withIdentifier: MediaType.movie.getView()) as? DetailView{
                    embedViewControllerWithCached(&detailPage)
                    self.navigationController?.pushViewController(detailPage, animated: true)
                }
            case .music:
                if var detailPage =  storyboard?.instantiateViewController(withIdentifier: MediaType.music.getView()) as? DetailView{
                    embedViewControllerWithCached(&detailPage)
                    self.navigationController?.pushViewController(detailPage, animated: true)
                }
            case .ebook:
                if var detailPage =  storyboard?.instantiateViewController(withIdentifier: MediaType.ebook.getView()) as? DetailView{
                    embedViewControllerWithCached(&detailPage)
                    self.navigationController?.pushViewController(detailPage, animated: true)
                }
            case .podcast:
                if var detailPage =  storyboard?.instantiateViewController(withIdentifier: MediaType.podcast.getView()) as? DetailView{
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
            guard let MediaType = mediaType_State else { return }
            paginationOffSet += AppConstants.requestLimit
            isLoadingNextPage_Flag = true
            self.searchViewModel.searchInvoked(searchText, MediaType, paginationOffSet)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.isSearchActive_Flag{
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 25)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoadingNextPage_Flag {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 40)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            case UICollectionView.elementKindSectionFooter:
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
                loadingView = aFooterView
                loadingView?.backgroundColor = UIColor.clear
                return aFooterView
            case UICollectionView.elementKindSectionHeader:
                let aHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerreusableviewid", for: indexPath) as! HeaderReusableView
                headerView = aHeaderView
                return aHeaderView
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
            if elementKind == UICollectionView.elementKindSectionFooter && isLoadingNextPage_Flag {
                self.loadingView?.activityIndicator.startAnimating()
            }
            if elementKind == UICollectionView.elementKindSectionHeader && !isSearchActive_Flag {
                guard let MediaType = self.mediaType_State else { return }
                self.headerView?.setTitle(with: MediaType.get().capitalized)
            }
        }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
        if elementKind == UICollectionView.elementKindSectionHeader {
            // Should you do smth?
        }
        
    }
}

/* CollectionView - Flow */
extension SearchView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // INFO: SearchView+Pseudo.swift
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return defaultMinimumCellSpacing }
        flowLayout.minimumLineSpacing = defaultMinimumCellSpacing
        return flowLayout.minimumLineSpacing
    }
}

/* SearchBar - Delegate */
extension SearchView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hapticFeedbackSoft()
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let MediaType = mediaType_State else { return }
        
        if (0...2).contains(searchText.count){
            if items.isEmpty{
                resetAndTrend(MediaType)
            }
        } else {
            if (1...20).contains(items.count) {
                searchBar.resignFirstResponder()
            } else {
                paginationOffSet = 0
                self.resetAndSearch(searchText, MediaType, paginationOffSet)
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchViewModel.reset()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           
           timeControl?.invalidate()
           timeControl = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [weak self] (timer) in
               
               guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
               guard let MediaType = self?.mediaType_State else { return }
               
               if (0...2).contains(searchText.count){
                   self?.isSearchActive_Flag = false
                   self?.activityIndicatorOverall.stopAnimating()
               }
               if searchText.count > 2 {
                   self?.isSearchActive_Flag = true
                   guard let offSet = self?.paginationOffSet else { return }
                   self?.resetAndSearch(searchText, MediaType, offSet)
               }
           })
   }
}














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
    func setItems( _ items: [RowItem])
    func invokeTopIds( _ topIds: [Top])
    
    // data specific
    func reset()
    func resetAndSearch(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int?)
    func resetAndTrend(_ mediaType: MediaType)
    
    // UI specific
    func dismissKeyBoard()
    func setReusableViewTitle(with title: String)
    func stopReusableViewActivityIndicator()
    func startReusableViewActivityIndicator()
    func stopActivityIndicator()
    func startActivityIndicator()
    func reloadCollectionView()
    
}

final class SearchView: UIViewController{
    
    private let cell_ID = HardCoded.cellIdentifier.get()
    
    let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
    let hapticSoft = UIImpactFeedbackGenerator(style: .soft)
    
    @IBOutlet private weak var activityIndicatorOverall: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var  searchViewModel = SearchViewModel()
    private lazy var detailViewModel = DetailViewModel()

    private var items: [RowItem] = []
    var mediaType_State: MediaType? = .movie

    
    
    private var idsOfAllFetchedRecords = Set<Int>()
    private var timeControl: Timer?
    
    private var loadingView: LoadingReusableView?
    private var headerView: HeaderReusableView?
    private var cacheDetails: [Int : Detail] = [:]
    private var cacheDetailImagesAndColors: [Int : (UIImage, UIColor)] = [:]
    private var paginationOffSet = 0
    private let dimension = AppConstants.imageDimensionForDetail
    private let cellSize = AppConstants.defaultCellSize
    private var sizingValue = AppConstants.defaultSizingValue
    private var cellSpacing = AppConstants.defaultMinimumCellSpacing
    private var columnCount = AppConstants.collectionViewColumn
    private let sectionInset = AppConstants.defaultSectionInset
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewModel.viewDidLoad()
    }
    // TODO: migrate
    func provideImageAndColor(_ imageUrl: String, completion: @escaping ((artwork: UIImage, colorAverage: UIColor)?) -> Void) {
        guard let modifiedArtworkUrl = changeImageURL(imageUrl, dimension: dimension) else {
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
    // TODO: migrate as a helper
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
        searchViewModel.topInvoked()
    }
    func startPrefetchingDetails(for ids: [Int]) {
        detailViewModel.searchInvoked(withIds: ids)
    }
    func setItems( _ items: [SearchCellModel]) {
        searchViewModel.setItems(items)
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(400)) {
            self.stopActivityIndicator()
            self.reloadCollectionView()
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
    func dismissKeyBoard() {
        searchBar.resignFirstResponder()
    }
    func setReusableViewTitle(with title: String) {
        self.headerView?.setTitle(with: title)
    }
    func stopReusableViewActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView?.activityIndicator.stopAnimating()
        }
    }
    func startReusableViewActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView?.activityIndicator.startAnimating()
        }
    }
    func stopActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorOverall.stopAnimating()
        }
    }
    func startActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorOverall.startAnimating()
        }
    }
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
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
        collectionView?.register(.init(nibName: cell_ID, bundle: nil), forCellWithReuseIdentifier: cell_ID)
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
// TODO: not sure ???
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
        searchViewModel.itemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_ID, for: indexPath) as! SearchCell
        
        cell.setImageHeigth( 2 * sizingValue )
        cell.setImageWidth( 2 * sizingValue )
        cell.setStackedLabelsHeigth( 2 * sizingValue )
        cell.setStackedLabelsWidth( 3 * sizingValue )
        
        cell.configureCell(with: searchViewModel.cellForItem(at: indexPath))
        return cell
    }
}

/* CollectionView - Delegate */
extension SearchView: UICollectionViewDelegate {
    
    // TODO: Migrate logic to VM
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
        guard let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        searchViewModel.willDisplay( at: indexPath, with: searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        searchViewModel.referenceSizeForHeaderInSection(collectionView.bounds.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        searchViewModel.referenceSizeForFooterInSection(collectionView.bounds.size.width)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            case UICollectionView.elementKindSectionFooter:
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HardCoded.loadingReusableIdentifier.get(), for: indexPath) as! LoadingReusableView
                loadingView = aFooterView
                loadingView?.backgroundColor = UIColor.clear
                return aFooterView
            case UICollectionView.elementKindSectionHeader:
            let aHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HardCoded.headerReusableIdentifier.get(), for: indexPath) as! HeaderReusableView
                headerView = aHeaderView
                return aHeaderView
        default:
            assert(false, HardCoded.errorPromptElementKind.get())
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        switch elementKind{
            case UICollectionView.elementKindSectionFooter:
                searchViewModel.willDisplaySupplementaryFooterView()
            case UICollectionView.elementKindSectionHeader:
                searchViewModel.willDisplaySupplementaryHeaderView()
        default:
            assert(false, HardCoded.errorPromptElementKind.get())
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind{
            case UICollectionView.elementKindSectionFooter:
                searchViewModel.didEndDisplayingSupplementaryView()
            case UICollectionView.elementKindSectionHeader:
                break
        default:
            assert(false, HardCoded.errorPromptElementKind.get())
        }
    }
}

/* CollectionView - Flow */
extension SearchView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // INFO: SearchView+Pseudo.swift
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return cellSize }
        let totalWidth = collectionView.bounds.width
        let sectionInsets = flowLayout.sectionInset
        let cellSpacingMin = ( (1.4) * (flowLayout.minimumInteritemSpacing) ) // band aid solution
        let totalInsetSpace = (CGFloat(columnCount)  * ( sectionInsets.left + sectionInsets.right ))
        let availableWidthForCells = (totalWidth - cellSpacingMin - totalInsetSpace)
        sizingValue =  ( availableWidthForCells / CGFloat(columnCount) ) / 5
        let cellWidth = sizingValue * 5
        let cellHeight = sizingValue * 2
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        return cellSize
        /* FIXME: NOT URGENT
                - Decreasing the multiplier causes one column
                - Increasing the multiplier causes the last item in the grid to clip to left item
                - But when user wants more data the last cell orients back to alignment
         */
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return sectionInset }
        flowLayout.sectionInset = sectionInset
        return flowLayout.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return cellSpacing }
        flowLayout.minimumInteritemSpacing = cellSpacing
        return flowLayout.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return cellSpacing }
        flowLayout.minimumLineSpacing = cellSpacing
        return flowLayout.minimumLineSpacing
    }
}

/* SearchBar - Delegate */
extension SearchView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hapticFeedbackSoft()
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        searchViewModel.searchBarSearchButtonClicked(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchViewModel.reset()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           
           timeControl?.invalidate()
           timeControl = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { [weak self] (timer) in
               
               guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
               self?.searchViewModel.textDidChange(with: searchText)
           })
   }
}














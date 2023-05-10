//
//  ViewController.swift
//  ItunesSearch-App
//

import UIKit
import Kingfisher


final class SearchView: UIViewController{
    
    @IBOutlet private weak var activityIndicatorOverall: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let hapticHeavy = UIImpactFeedbackGenerator(style: .heavy)
    let hapticSoft = UIImpactFeedbackGenerator(style: .soft)
    private var timeControl: Timer?
    
    private let cell_ID = AppConstants.cellIdentifier
    private let cellSize = AppConstants.defaultCellSize
    private var cellSpacing = AppConstants.defaultMinimumCellSpacing
    private let columnCount = AppConstants.collectionViewColumn
    private var sizingValue = AppConstants.defaultSizingValue
    private let imageDimension = AppConstants.imageDimensionForDetail
    private let sectionInset = AppConstants.defaultSectionInset
    
    private lazy var searchViewModel = SearchViewModel()
    private lazy var detailViewModel = DetailViewModel()
    
    private var loadingView: LoadingReusableView?
    private var headerView: HeaderReusableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewModel.view = self
        searchViewModel.viewDidLoad()
    }
}
/* Search View - Interface */
extension SearchView: SearchViewInterface {
    
    func assignPropsOfSearchViewModel() {
        searchViewModel.delegate = self
    }
    
    func assignPropsOfDetailViewModel() {
        detailViewModel.delegate = self
    }
    
    func assignPropsOfSearchBar() {
        searchBar.delegate = self
    }
    
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
        searchViewModel.topWithIdsInvoked(topIds)
    }
    
    func reset() {
        searchViewModel.reset()
    }
    
    func resetAndSearch(_ searchTerm: String, _ mediaType: MediaType, _ offSetValue: Int?) {
        searchViewModel.resetAndSearch(searchTerm, mediaType, offSetValue)
    }
    
    func resetAndTrend(_ mediaType: MediaType) {
        searchViewModel.resetAndTrend(mediaType)
    }
    
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
    
    func createDetailView(by storyBoardIdentifier: String) -> DetailView {
        storyboard?.instantiateViewController(withIdentifier: storyBoardIdentifier) as! DetailView
    }
    
    func pushDetailPageToNavigation(_ detailPage: DetailView) {
        self.navigationController?.pushViewController(detailPage, animated: true)
    }
    
    func configureDetailView(_ id: Int, _ detail: Detail, _ detailVC: inout DetailView, _ pair: ImageColorPair) {
        DispatchQueue.main.async { [weak detailVC] in
            detailVC?.id = id
            detailVC?.configureItem(with: detail, pair)
        }
    }
    /// Interface Helpers
    func assignPropsOfCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    func registersOfCollectionView() {
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
    
    func provideImageColorPair(_ imageUrl: String, completion: @escaping (ImageColorPair?) -> Void) {

        guard let artworkUrl = URL(string: searchViewModel.modifyUrl(imageUrl, imageDimension)) else { completion(nil) ; return }
        
        KingfisherManager.shared.retrieveImage(with: artworkUrl) { result in
            switch result {
            case .success(let value):
                guard let averagedColor = value.image.averageColor else {
                    completion(nil)
                    return
                }
                completion(.init(image: value.image, color: averagedColor))
            case .failure(_):
                completion(nil)
            }
        }
    }
}

///* Search View Model - Delegates */
extension SearchView: SearchViewModelDelegate {

    func refreshItems(_ retrieved: [SearchCellModel]) {
        setItems(retrieved)
        startPrefetchingDetails(for: searchViewModel.providesIds(retrieved))
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
/* Detail View Model - Delegates */
extension SearchView: DetailViewModelDelegate{
    func refreshItem(_ retrieved: [Detail]) {
        for each in retrieved{
            searchViewModel.setCacheDetails(key: each.id, value: each)
            
            provideImageColorPair( each.artworkUrl) { [weak self] pair in
                guard let pair = pair else { return }
                self?.searchViewModel.setCacheDetailImagesAndColor(key: each.id, value: pair)
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
        cell.setStackedLabelsHeight( 2 * sizingValue )
        cell.setStackedLabelsWidth( 3 * sizingValue )
        
        cell.configureCell(with: searchViewModel.cellForItem(at: indexPath))
        return cell
    }
}

/* CollectionView - Delegate */
extension SearchView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hapticFeedbackHeavy()
        searchViewModel.didSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        searchViewModel.willDisplay(at: indexPath, with: searchText)
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
        let cellSpacingMin = flowLayout.minimumInteritemSpacing
        let totalInsetSpace = (sectionInsets.left + sectionInsets.right)
        let totalCellSpacing = ((columnCount-1) * cellSpacingMin)
        let availableWidthForCells = (totalWidth - totalCellSpacing - totalInsetSpace)
        sizingValue =  (availableWidthForCells / CGFloat(columnCount)) / 5
        let cellWidth = sizingValue * 5
        let cellHeight = sizingValue * 2
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        return cellSize
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














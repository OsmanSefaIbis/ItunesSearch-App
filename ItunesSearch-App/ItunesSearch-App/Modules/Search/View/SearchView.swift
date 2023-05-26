//
//  ViewController.swift
//  ItunesSearch-App
//

import UIKit
import Kingfisher

final class SearchView: UIViewController{
    
    @IBOutlet private weak var spinnerCollectionView: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var pagingSpinner: PagingSpinnerReusableFooter?
    private var topPicksBar: TopPicksReusableHeader?
    
    private lazy var searchViewModel = SearchViewModel()
    private lazy var detailViewModel = DetailViewModel()
    
    private var sizingValue = ConstantsCV.sizingValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewModel.view = self
        searchViewModel.viewDidLoad()
    }
}
/* Search View - Contract */
extension SearchView: SearchViewContract {
    
    func assignDelegates() {
        searchViewModel.delegate = self
        detailViewModel.delegate = self
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
    
    func configureSpinner() {
        spinnerCollectionView.color = ConstantsApp.spinnerColor
    }
    
    func initiateTopResults() {
        startSpinner()
        searchViewModel.topInvoked()
    }
    
    func startPrefetchingDetails(for ids: [Int]) {
        detailViewModel.searchInvoked(withIds: ids)
    }
    
    func invokeTopIds( _ topIds: [Top]) {
        searchViewModel.topWithIdsInvoked(topIds)
    }
    
    func resetAndSearch(with query: SearchQuery) {
        searchViewModel.resetAndSearch(with: query)
    }
    
    func resetAndInvokeTop() {
        searchViewModel.resetAndInvokeTop()
    }
    
    func setItems( _ items: [SearchCellModel]) {
        searchViewModel.setItems(items, completion: {
            self.stopSpinner()
            self.reloadCollectionView()
        })
    }
    
    func reset() {
        searchViewModel.reset()
    }
    
    func setReusableViewTitle(with title: String) {
        self.topPicksBar?.setTitle(with: title)
    }
    
    func stopReusableViewSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pagingSpinner?.spinner.stopAnimating()
        }
    }
    
    func startReusableViewSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pagingSpinner?.spinner.startAnimating()
        }
    }
    
    func stopSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.spinnerCollectionView.stopAnimating()
        }
    }
    
    func startSpinner() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.spinnerCollectionView.startAnimating()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func initiateDetailCreation(with foundation: CompactDetail){
        detailViewModel.view = storyboard?.instantiateViewController(withIdentifier: foundation.media.getView()) as! DetailView
        detailViewModel.view?.loadViewIfNeeded()
        detailViewModel.view?.viewModel = detailViewModel
        detailViewModel.assembleView(by: foundation)
    }
    
    func pushPageToNavigation(push thisPage: UIViewController) {
        self.navigationController?.pushViewController(thisPage, animated: true)
    }
    
    func dismissKeyBoard() {
        searchBar.resignFirstResponder()
    }
    
    /// Contract Helpers
    func assignPropsOfCollectionView() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    func registersOfCollectionView() {
        let loadingReusableNib = UINib(nibName: HardCoded.loadingReusableName.get(), bundle: nil)
        let headerReusableNib = UINib(nibName: HardCoded.headerReusableName.get(), bundle: nil)
        collectionView?.register(.init(nibName: ConstantsCV.cell_ID, bundle: nil), forCellWithReuseIdentifier: ConstantsCV.cell_ID)
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
        
        guard let artworkUrl = URL(string: searchViewModel.modifyUrl(imageUrl, ConstantsCV.detailImageDimension)) else { completion(nil) ; return }
        
        KingfisherManager.shared.retrieveImage(with: artworkUrl) { result in
            switch result {
            case .success(let value):
                if let averagedColor = value.image.averageColor {
                    completion(.init(image: value.image, color: averagedColor))
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
}

///* Search View Model - Delegates */
extension SearchView: SearchViewModelDelegate {

    func renderItems(_ retrieved: [SearchCellModel]) {
        setItems(retrieved)
        startPrefetchingDetails(for: searchViewModel.providesIds(retrieved))
    }
    func topItems(_ retrieved: [Top]) {
        invokeTopIds(retrieved)
    }
    func internetUnreachable(_ errorPrompt: String) {
        let alertController = UIAlertController(title: HardCoded.offLineAlertTitlePrompt.get(), message: errorPrompt, preferredStyle: .alert )
        let okAction = UIAlertAction(title: HardCoded.offLineActionTitlePrompt.get(), style: .default) { [weak self] (action:UIAlertAction!) in
            guard let self else { return }
            self.searchViewModel.reset()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
/* Detail View Model - Delegates */
extension SearchView: DetailViewModelDelegate{
    func storeItem(_ retrieved: [Detail]) {
        for each in retrieved{
            searchViewModel.setCacheDetails(key: each.id, value: each)
            
            provideImageColorPair(each.artworkUrl) { [weak self] pair in
                guard let self else { return }
                self.searchViewModel.setCacheDetailImagesAndColor(key: each.id, value: pair)
            }
        }
    }
    func passPage(_ page: DetailView) {
        pushPageToNavigation(push: page)
    }
}
    
/* CollectionView - Data */
extension SearchView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchViewModel.itemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsCV.cell_ID, for: indexPath) as! SearchCell
        cell.configureCell(with: searchViewModel.cellForItem(at: indexPath), size: sizingValue )
        
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
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HardCoded.loadingReusableIdentifier.get(), for: indexPath) as! PagingSpinnerReusableFooter
                pagingSpinner = aFooterView
                pagingSpinner?.backgroundColor = UIColor.clear
                return aFooterView
            case UICollectionView.elementKindSectionHeader:
            let aHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HardCoded.headerReusableIdentifier.get(), for: indexPath) as! TopPicksReusableHeader
                topPicksBar = aHeaderView
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
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return ConstantsCV.cellSize }
        let totalWidth = collectionView.bounds.width
        let sectionInsets = flowLayout.sectionInset
        let cellSpacingMin = flowLayout.minimumInteritemSpacing
        let totalInsetSpace = (sectionInsets.left + sectionInsets.right)
        let totalCellSpacing = ((ConstantsCV.columnCount-1) * cellSpacingMin)
        let availableWidthForCells = (totalWidth - totalCellSpacing - totalInsetSpace)
        sizingValue = ( availableWidthForCells / CGFloat(ConstantsCV.columnCount) ) / 5
        let cellWidth = sizingValue * 5
        let cellHeight = sizingValue * 2
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return ConstantsCV.sectionInset }
        flowLayout.sectionInset = ConstantsCV.sectionInset
        return flowLayout.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return ConstantsCV.cellSpacing }
        flowLayout.minimumInteritemSpacing = ConstantsCV.cellSpacing
        return flowLayout.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return ConstantsCV.cellSpacing }
        flowLayout.minimumLineSpacing = ConstantsCV.cellSpacing
        return flowLayout.minimumLineSpacing
    }
}

/* SearchBar - Delegate */
extension SearchView: UISearchBarDelegate { 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hapticFeedbackSoft()
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        searchViewModel.searchBarSearchButtonClicked(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchViewModel.reset()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchViewModel.textDidChange(with: searchText)
    }
}














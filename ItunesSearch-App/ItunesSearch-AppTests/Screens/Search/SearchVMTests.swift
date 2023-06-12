//
//  SearchVMTests.swift
//  ItunesSearch-AppTests
//
//  Created by Sefa İbiş on 12.06.2023.
//

@testable import ItunesSearch_App
import XCTest

final class SearchVMTests: XCTestCase {
    
    private var viewModel: SearchVM!
    private var view: MockSearchVC!
    
    override func setUp() {
        super.setUp()
        view = .init()
        viewModel = .init(view: view)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
/* Contract Related */
    
    /// viewDidLoad()
    func test_viewDidLoad_invokesRequiredSequences(){
        
    }
    
    /// topInvoked()
    
    /// topWithIdsInvoked(_ topIds: [Top])
    
    /// searchInvoked(with query: SearchQuery)
    
    /// segmentedControlValueChanged(to indexValue: Int, with searchText: String)
    
    /// cellForItem(at indexPath: IndexPath) -> ColumnItem
    
    /// didSelectItem(at indexPath: IndexPath)
    
    /// willDisplay(at indexPath: IndexPath, with searchText: String)
    
    /// referenceSizeForHeaderInSection(_ width: CGFloat) -> CGSize
    
    /// referenceSizeForFooterInSection(_ width: CGFloat) -> CGSize
    
    /// willDisplaySupplementaryFooterView()
    
    /// willDisplaySupplementaryHeaderView()
    
    /// didEndDisplayingSupplementaryView()
    
    /// searchBarSearchButtonClicked(with searchText: String)
    
    /// searchBarCancelButtonClicked()
    
    /// textDidChange(with searchText: String)
    
    /// setItems(_ items: [ColumnItem], completion: (() -> Void)?)
    
    /// reset()
    
    /// resetAndSearch(with query: SearchQuery)
    
    /// resetAndInvokeTop()
    
    /// modifyUrl(_ imageUrl: String, _ imageDimension: Int) -> String
    
    /// providesIds(_ items: [ColumnItem]) -> [Int]
    
    /// setCacheDetails(key id: Int, value detail: Detail)
    
    /// setCacheDetailImagesAndColor( key id: Int, value pair: ImageColorPair)
    
/* Communication Related */
    
    
    
    
}

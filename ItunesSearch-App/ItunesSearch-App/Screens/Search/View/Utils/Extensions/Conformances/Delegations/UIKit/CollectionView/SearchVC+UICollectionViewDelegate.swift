//
//  SearchVC+UICollectionViewDelegate.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 28.05.2023.
//

import UIKit

extension SearchVC: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        hapticFeedbackHeavy()
        searchViewModel.didSelectItem(at: indexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        
        guard let searchText = searchBar.text?.replacingOccurrences(of: "\\s+", with: "+", options: .regularExpression) else { return }
        searchViewModel.willDisplay(at: indexPath, with: searchText)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
        searchViewModel.referenceSizeForHeaderInSection(collectionView.bounds.size.width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        
        searchViewModel.referenceSizeForFooterInSection(collectionView.bounds.size.width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
                if searchViewModel.isLessThanPage_Flag || searchViewModel.isTopPicksActive_Flag {
                    let barFooterView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: HardCoded.footerReusableIdentifier.get(),
                        for: indexPath
                    ) as! ReusableFooterBar
                    footerBar = barFooterView
                    return barFooterView
                } else if searchViewModel.isLoadingNextPage_Flag {
                    let pagingFooter = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: HardCoded.loadingReusableIdentifier.get(),
                        for: indexPath
                    ) as! PagingSpinnerReusableFooter
                    pagingSpinner = pagingFooter
                    pagingSpinner?.backgroundColor = UIColor.clear
                    return pagingFooter
                }
        case UICollectionView.elementKindSectionHeader:
            let barHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HardCoded.headerReusableIdentifier.get(),
                for: indexPath
            ) as! ReusableHeaderBar
            headerBar = barHeaderView
            return barHeaderView
            
        default:
            assert(false, HardCoded.errorPromptElementKind.get())
        }
        
        return UICollectionReusableView()
    }

    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        
        switch elementKind{
            case UICollectionView.elementKindSectionFooter:
                searchViewModel.willDisplaySupplementaryFooterView()
            case UICollectionView.elementKindSectionHeader:
                searchViewModel.willDisplaySupplementaryHeaderView()
        default:
            assert(false, HardCoded.errorPromptElementKind.get())
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplayingSupplementaryView view: UICollectionReusableView,
        forElementOfKind elementKind: String,
        at indexPath: IndexPath
    ) {
        
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

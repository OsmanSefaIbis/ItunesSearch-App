//
//  DetailVC+DetailViewContractHelper.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 29.05.2023.
//

import Foundation

extension DetailVC {
    
/// Helps -> SearchVC+SearchViewContract
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        removeAudioRelated()
        viewModel?.toggleAudio()
    }
}

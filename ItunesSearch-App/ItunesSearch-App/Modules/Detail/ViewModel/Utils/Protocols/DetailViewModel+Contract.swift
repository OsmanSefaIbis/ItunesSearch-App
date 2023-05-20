//
//  DetailViewModel+Interface.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation
// laterTODO: order properly, order class
// laterTODO: Analyze this interface properly to make it as neat as possible
protocol DetailViewModelContract {
    
    var view: DetailViewContract? { get set }
    func assembleView(by foundation: CompactDetail, with skeleton: DetailView )
    func configureItem(with item: Detail, _ pair: ImageColorPair)
    func convertDate(_ date: String) -> String
    func handlePrice(_ price: Double) -> String
    func handleDescription(_ description: String) -> String
    func handleTime(millis: Int) -> String
    func handleTime(seconds: Int) -> String
    func handleCollectionName(_ name: String) -> String
    func handleByteRepresentation(_ byte: Int) -> String
    func handleJoin(_ list: [String]) -> String
    func handleRating(_ count: Int) -> String
    func handleRating(_ rate: Double) -> String
    func constructTrackInfo(_ track: Int, _ album: Int) -> String
    func constructEpisodeInfo(_ count: Int) -> String
    func musicPreviewButtonClicked(_ url: URL)
    func toggleAudio()
}

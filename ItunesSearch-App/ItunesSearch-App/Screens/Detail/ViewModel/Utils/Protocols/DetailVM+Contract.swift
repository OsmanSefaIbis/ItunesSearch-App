//
//  DetailViewModel+Interface.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation

protocol DetailVMContract {
    
    /// prop
    var view: DetailViewContract? { get set }
    /// fetch invocation
    func searchInvoked(withIds idValues: [Int])
    func cacheMissInvoked(for query: CachingQuery)
    /// configure for view
    func assembleView(by foundation: CompactDetail)
    func configureItem(with item: Detail, _ pair: ImageColorPair, completion: (() -> Void)?)
    /// data formatting
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
    /// operations
    func musicPreviewButtonClicked(_ url: URL)
    func isAudioActive() -> Bool
    func toggleAudio()
}

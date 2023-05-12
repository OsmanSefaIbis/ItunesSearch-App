//
//  DetailViewModel+Interface.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 9.05.2023.
//

import Foundation
// TODO: order properly, order class
// TODO: Analyze this interface properly to make it as neat as possible
protocol DetailViewModelInterface {
    
    var view: DetailViewInterface? { get set }
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
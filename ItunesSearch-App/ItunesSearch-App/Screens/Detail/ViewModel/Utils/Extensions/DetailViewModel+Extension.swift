//
//  DetailViewModelExtension.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 24.05.2023.
//

import Foundation

extension DetailViewModel {
    
    func handlePrice(_ price: Double) -> String {
        price <= 0 ? HardCoded.free.get() : (HardCoded.dolar.get()).appending(String(price))
    }
    
    func handleCollectionName(_ name: String) -> String{
        name.isEmpty ? HardCoded.notAvailable.get() : name
    }
    
    func handleJoin(_ list: [String]) -> String {
        list.joined(separator: HardCoded.seperator.get())
    }
    
    func handleRating(_ count: Int) -> String {
        count == 0 ? HardCoded.noRating.get() : (HardCoded.numberSign.get()).appending(String(count))
    }
    
    func handleRating(_ rate: Double) -> String {
        rate == 0.0 ? HardCoded.noRating.get() : String(rate).appending(HardCoded.ratingScale.get())
    }
    
    func constructTrackInfo(_ track: Int, _ album: Int) -> String {
        String(track).appending(HardCoded.trackSeperator.get()).appending(String(album))
    }
    
    func constructEpisodeInfo(_ count: Int) -> String {
        (HardCoded.numberSign.get()).appending(String(count))
    }
}

//
//  DetailVM+DetailViewModelContract.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 29.05.2023.
//

import Foundation

extension DetailVM: DetailVMContract {
    
    func searchInvoked(withIds idValues: [Int]){
        model.fetchIdResults(for: idValues)
    }
    
    func cacheMissInvoked(for query: CachingQuery){
        model.fetchIdResultForCacheMiss(with: query)
    }
    
    func assembleView(by foundation: CompactDetail){
        view?.configureView(with: foundation.data, foundation.imageAndColor) {
            guard let detailPage = self.view else { return }
            self.delegate?.passPage(detailPage as! DetailVC)
        }
    }
     
    func configureItem(with item: Detail, _ pair: ImageColorPair, completion: (() -> Void)?) {
        
        guard let isColorDark = view?.isColorDark(pair.color) else { return }
        
        if isColorDark{
            view?.setTextColorOfView(.white)
            view?.adaptComponentsForDark(.white)
        } else {
            view?.setNavigationBarWith(tintColor: ConstantsApp.accentColorName)
        }
        view?.configureMutualFields(item, pair)
        
        switch item.kind{
            case MediaType.movie.getKind():     view?.configureMovie(item)
            case MediaType.music.getKind():     view?.configureMusic(item)
            case MediaType.ebook.getKind():     view?.configureEbook(item)
            case MediaType.podcast.getKind():   view?.configurePodcast(item)
        default:
            assert(false, HardCoded.errorPromptKind.get())
        }
        completion?()
    }
    
    func convertDate(_ date: String) -> String {
        view?.convertDate(for: date) ?? ""
    }
    
    func handlePrice(_ price: Double) -> String {
        price <= 0 ? HardCoded.free.get() : (HardCoded.dolar.get()).appending(String(price))
    }
    
    func handleDescription(_ description: String) -> String {
        view?.capitalizeUppercaseWords(input: description) ?? ""
    }
    
    func handleTime(millis: Int) -> String {
        view?.readableFormatTimeFromMillis(millis: millis) ?? ""
    }
    func handleTime(seconds: Int) -> String {
        view?.readableFormatTimeFromSeconds(seconds: seconds) ?? ""
    }
    
    func handleCollectionName(_ name: String) -> String{
        name.isEmpty ? HardCoded.notAvailable.get() : name
    }
    
    func handleByteRepresentation(_ byte: Int) -> String {
        view?.convertBytesToGBorMB(byte) ?? ""
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
    
    
    func musicPreviewButtonClicked(_ url: URL) {
        
        if isAudioPlaying {
            view?.toggleAudioOff()
        } else {
            view?.toggleAudioOn(url)
        }
        isAudioPlaying.toggle()
    }
    
    func isAudioActive() -> Bool{
        isAudioPlaying
    }
    
    func toggleAudio() {
        isAudioPlaying.toggle()
    }
}


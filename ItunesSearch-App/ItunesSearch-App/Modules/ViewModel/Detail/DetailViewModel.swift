//
//  DetailViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation
// laterTODO: Add a extension file
// laterTODO: migrate independant methods to extension file for this class
final class DetailViewModel{
    
    private let model = DetailModel()
    
    weak var view: DetailViewInterface?
    weak var delegate: DetailViewModelDelegate?
    
    private var isAudioPlaying = false
    
    init(){
        model.delegate = self
    }
    func searchInvoked(withIds idValues: [Int]){
        model.fetchIdResults(for: idValues)
    }
}

extension DetailViewModel: DetailModelDelegate{

    func didFetchDetailData(){
        let retrievedData: [Detail] = model.detailResults.map{    //searchTODO: Is there a better approach?
            .init(
                id: $0.trackID ?? 0,
                kind: $0.kind ?? "",
                artworkUrl: $0.artworkUrl100 ?? "",
                description: $0.description ?? "",
                longDescription: $0.longDescription ?? "",
                name: $0.trackName ?? "",
                creator: $0.artistName ?? "",
                collectionName: $0.collectionName ?? "",
                releaseDate: $0.releaseDate ?? "",
                episodeCount: $0.trackCount ?? 0,               
                genre: $0.primaryGenreName ?? "",
                advisory: $0.contentAdvisoryRating ?? "",
                price: $0.trackPrice ?? 0,
                trackNumber: $0.trackNumber ?? 0,
                albumNumber: $0.trackCount ?? 0,
                length: $0.trackTimeMillis ?? 0,
                size: $0.fileSizeBytes ?? 0,
                ratingCount: $0.userRatingCount ?? 0,
                rating: $0.averageUserRating ?? 0,
                genreList: $0.genres ?? [""],
                previewUrl: $0.previewURL ?? "",
                viewUrl: $0.trackViewURL ?? ""
            )
        }
        self.delegate?.refreshItem(retrievedData)
    }
    func failedDataFetch() {
        delegate?.internetUnreachable(HardCoded.offlinePrompt.get())
    }
}

extension DetailViewModel: DetailViewModelInterface {
    
    func assembleView(by foundation: CompactDetail, with skeloton: DetailView){
        view?.configureView(with: foundation.data, foundation.imageAndColor, with: skeloton)
        guard let detailPage = self.view else { return }
        self.delegate?.passPage(detailPage as! DetailView)
    }
    
    func configureItem(with item: Detail, _ pair: ImageColorPair) {

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
    
    func toggleAudio() {
        isAudioPlaying.toggle()
    }
    
    
}

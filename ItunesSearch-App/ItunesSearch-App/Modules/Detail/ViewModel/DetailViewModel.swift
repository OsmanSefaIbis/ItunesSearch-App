//
//  DetailViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation

final class DetailViewModel{
    
    private let model = DetailModel()
    
    weak var view: DetailViewContract?
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
        let retrievedData: [Detail] = model.detailResults.map{    
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
        self.delegate?.storeItem(retrievedData)
    }
    func failedDataFetch() {
        delegate?.internetUnreachable(HardCoded.offlinePrompt.get())
    }
}

extension DetailViewModel: DetailViewModelContract {
    
    func assembleView(by foundation: CompactDetail){
        view?.configureView(with: foundation.data, foundation.imageAndColor) { 
            guard let detailPage = self.view else { return }
            self.delegate?.passPage(detailPage as! DetailView)
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

    func handleDescription(_ description: String) -> String {
        view?.capitalizeUppercaseWords(input: description) ?? ""
    }
    
    func handleTime(millis: Int) -> String {
        view?.readableFormatTimeFromMillis(millis: millis) ?? ""
    }
    func handleTime(seconds: Int) -> String {
        view?.readableFormatTimeFromSeconds(seconds: seconds) ?? ""
    }
    
    func handleByteRepresentation(_ byte: Int) -> String {
        view?.convertBytesToGBorMB(byte) ?? ""
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

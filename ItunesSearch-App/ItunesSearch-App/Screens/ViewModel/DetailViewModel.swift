//
//  DetailViewModel.swift
//  ItunesSearch-App
//
//  Created by Sefa İbiş on 17.04.2023.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject{
    func refreshItem(_ retrieved: [Detail])
}

class DetailViewModel{
    private let model = DetailModel()
    weak var delegate: DetailViewModelDelegate?
    
    init(){
        model.delegate = self
    }
    func didViewLoad(withId idValue: Int){
        model.fetchSingularData(for: idValue)
    }
}

extension DetailViewModel: DetailModelDelegate{
    func dataDidFetch(){
        let retrievedData: [Detail] = model.dataFetched.map{
            
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
}

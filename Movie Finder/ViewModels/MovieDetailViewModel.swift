//
//  MovieDetailViewModel.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    
    func loadData()
}

protocol MovieDetailViewModelDelegate: AnyObject {
    func show(movie: FullMoviePresentation)
    func show(actors: [ActorPresentation])
    func show(error: String)
    func setLoading(show: Bool)
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate?
    
    let imdbID: String

    var movieData: FullMovieData!
    init(imdbID: String) {
        self.imdbID = imdbID
    }
    
    func loadData() {
        
        MFApi.sharedInstance.getMovieWith(imdbId: imdbID) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.movieData = data
                let moviePresentation = FullMoviePresentation(model: self.movieData)
                self.delegate?.show(movie: moviePresentation)
                MFAnalyticsHelper.shared.logMovie(movie: self.movieData)
                self.showActors()
            case .failure(let error):
                self.handle(error: error)
            }
        }
    }
    
    func showActors() {
        if let actorsCollectionString = movieData.actors {
            let actorsArray = actorsCollectionString.split(separator: ",")
            let actorsPresentation = actorsArray.map { (element) -> ActorPresentation in
                let actor = ActorPresentation(name: String(element), image: nil)
                return actor
            }
            delegate?.show(actors: actorsPresentation)
        }
    }
    
    func handle(error: NetworkError) {
        delegate?.show(error: "An unexpected error ocurred")
    }
}

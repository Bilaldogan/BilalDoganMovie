//
//  MovielListViewModelProtocol.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation

protocol MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate? { get set }

    func loadSampleData()
    func getMoviesWith(searchKey: String?)
    func cancelSearch()
    func movieSelected(at index: Int)
}

protocol MovieListViewModelDelegate: AnyObject {
    func show(movies: [ShortMoviePresentation])
    func show(error: String)
    func setLoading(show: Bool)
    func openDetailWith(imdbID: String)
}

final class MovieListViewModel: MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate?
    
    private var sampleMovies = [ShortMovieData]()
    private var searchedMovies = [ShortMovieData]()
    
    func loadSampleData() {
        delegate?.setLoading(show: true)
        MFApi.sharedInstance.getMoviesWith(searchKey: "lord") { [weak self] (result) in
            guard let self = self else {return}
            self.delegate?.setLoading(show: false)
            switch result {
            case .success(let data):
                self.sampleMovies = data.search ?? [ShortMovieData]()
                self.showMovies()
            case .failure(let error):
                self.handleError(networkError: error)
            }
        }
    }
    
    func getMoviesWith(searchKey: String?) {
        self.searchedMovies.removeAll()
        if searchKey?.isEmpty ?? false {
            showMovies()
            return
        }
        delegate?.setLoading(show: true)
        MFApi.sharedInstance.getMoviesWith(searchKey: searchKey! ) { [weak self] (result) in
            guard let self = self else {return}
            self.delegate?.setLoading(show: false)
            switch result {
            case .success(let data):
                self.searchedMovies = data.search ?? [ShortMovieData]()
                if self.searchedMovies.count < 1 {
                    self.handleError(networkError: .invalidResponse)
                }
                self.showMovies()
            case .failure(let error):
                self.handleError(networkError: error)
            }
        }
    }
    
    func cancelSearch() {
        self.searchedMovies.removeAll()
        showMovies()
    }
    
    func movieSelected(at index: Int) {
        if searchedMovies.count > 0 {
            if let imdbId = searchedMovies[index].imdbID {
                self.delegate?.openDetailWith(imdbID: imdbId)
            } else {
                self.delegate?.show(error: "An unexpected error has occurred.")
            }
        } else {
            if let imdbId = sampleMovies[index].imdbID {
                self.delegate?.openDetailWith(imdbID: imdbId)
            } else {
                self.delegate?.show(error: "An unexpected error has occurred.")
            }
        }
    }
    
    private func showMovies() {
        if searchedMovies.count > 0 {
            let movies = searchedMovies.map({ShortMoviePresentation(model: $0)})
            self.delegate?.show(movies: movies)
        } else {
            let movies = sampleMovies.map({ShortMoviePresentation(model: $0)})
            self.delegate?.show(movies: movies)
        }
    }
    
    private func handleError(networkError: NetworkError) {
        switch networkError {
        case .invalidResponse:
            self.delegate?.show(error: "No movies found for your search")
        case .unknown:
            self.delegate?.show(error: "An unexpected error has occurred.")
        }
    }
    
    
}

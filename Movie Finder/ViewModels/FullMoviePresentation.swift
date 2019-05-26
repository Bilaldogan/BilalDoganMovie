//
//  FullMoviePresentation.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation

struct FullMoviePresentation {
    
    let title: String
    let year: String
    let released: String
    let runtime: String
    let genre: String
    let poster: URL?
    let director: String
    let writer: String
    let plot: String
    let language: String
    let awards: String
    let imdbRating: String
    let website: String
    
    init(model: FullMovieData) {
        title = model.title ?? "Title: Unkown"
        year = model.year ?? "Year: Unkown"
        released = model.released ?? "Release: Unkown"
        runtime = model.runtime ?? "--"
        genre = model.genre ?? "Genre: Unkown"
        director = model.director ?? "Unkown"
        writer = model.writer ?? "Unkown"
        plot = model.plot ?? "Unkown"
        language = model.language ?? "Unkown"
        awards = model.awards ?? "Unkown"
        imdbRating = model.imdbRating ?? "--"
        website = model.website ?? "Unkown"
        poster = URL(string: model.poster ?? "")
    }
}

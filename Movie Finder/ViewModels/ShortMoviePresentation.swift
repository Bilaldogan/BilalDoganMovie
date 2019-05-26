//
//  ShortMoviePresentation.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation

struct ShortMoviePresentation {
    let title: String
    let year: String
    let type: String
    let posterURL: URL?
    
    init(model: ShortMovieData) {
        title = model.title ?? "Title: Unkown"
        year = model.year ?? "Year: Unkown"
        type = model.type ?? "Type: Unkown"
        posterURL = URL(string: model.poster ?? "")
    }
}

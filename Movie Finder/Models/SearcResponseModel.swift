//
//  SearcResponseModel.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import Foundation
struct SearchResponseModel: Codable {
    var search: [ShortMovieData]?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
struct ShortMovieData: Codable {
    var title: String?
    var year: String?
    var imdbID: String?
    var type: String?
    var poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
}


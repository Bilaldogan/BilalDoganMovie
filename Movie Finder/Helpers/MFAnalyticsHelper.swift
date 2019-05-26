//
//  MFAnalyticsHelper.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import FirebaseAnalytics

class MFAnalyticsHelper {
    static var shared = MFAnalyticsHelper()
    
    func logMovie(movie:FullMovieData) {
        Analytics.logEvent("movie_detail",
                           parameters: [
                            "item" : movie.title as Any,
                            "genre" : movie.genre as Any,
                            "imdbRating" : movie.imdbRating as Any,
                            "director" : movie.director as Any])
        
    }
}

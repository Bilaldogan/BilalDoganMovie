//
//  MovieCell.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import UIKit
import SDWebImage
class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(movie: ShortMoviePresentation) {
        movieTitleLabel.text = movie.title
        posterImageView.sd_setImage(with: movie.posterURL, placeholderImage: UIImage(named: "poster-placeholder"))
        typeLabel.text = movie.type
        yearLabel.text = movie.year
    }
    
}

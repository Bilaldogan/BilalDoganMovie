//
//  MovieDetailViewController.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 26.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import UIKit

class MovieDetailViewController: BaseViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var releasedDateLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var awardsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    
    var viewModel: MovieDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    var actors = [ActorPresentation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
        actorsCollectionView.register(cellWithClass: ActorCell.self)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        coordinator?.backTapped()
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func show(movie: FullMoviePresentation) {
        self.titleLabel.text = movie.title
        self.genreLabel.text = movie.genre
        self.runtimeLabel.text = movie.runtime
        self.imdbRatingLabel.text = movie.imdbRating
        self.releasedDateLabel.text = movie.released
        self.plotLabel.text = movie.plot
        self.directorLabel.text = movie.director
        self.writerLabel.text = movie.writer
        self.awardsLabel.text = movie.awards
        self.languageLabel.text = movie.language
        self.websiteLabel.text = movie.website
        self.posterImageView.sd_setImage(with: movie.poster, completed: nil)
    }
    
    func show(actors: [ActorPresentation]) {
        self.actors = actors
        actorsCollectionView.reloadData()
    }
    
    func show(error: String) {
        self.showError(message: error)
    }
    
    func setLoading(show: Bool) {
        if show {
            self.showHUD()
        } else {
            self.hideHUD()
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ActorCell.self, for: indexPath)
        let actor = actors[indexPath.row]
        cell.configureWith(actor: actor)
        return cell
    }
    
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 128)
    }
}

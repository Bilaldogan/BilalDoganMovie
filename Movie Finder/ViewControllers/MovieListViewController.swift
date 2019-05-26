//
//  MovieListViewController.swift
//  Movie Finder
//
//  Created by Bilal Doğan on 25.05.2019.
//  Copyright © 2019 Bilal Doğan. All rights reserved.
//

import UIKit

class MovieListViewController: BaseViewController,Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: MainCoordinator?
    
    var viewModel: MovieListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    var movieList = [ShortMoviePresentation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.title = "Movie Finder"
        tableView.register(nibWithCellClass: MovieCell.self)
        viewModel.loadSampleData()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchContoller = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchContoller
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.placeholder = "Type and Find Movies"
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

}

extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MovieCell.self, for: indexPath)
        cell.configureWith(movie: movieList[indexPath.row])
        return cell
    }
    
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       viewModel.movieSelected(at: indexPath.row)
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func setLoading(show: Bool) {
        if show {
            self.showHUD()
        } else {
            self.hideHUD()
        }
    }
    
    func show(movies: [ShortMoviePresentation]) {
        self.movieList = movies
        tableView.reloadData()
    }
    
    func show(error: String) {
        self.showError(message: error)
    }
    
    func openDetailWith(imdbID: String) {
        coordinator?.openDetail(imdbID: imdbID)
    }
    
}

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getMoviesWith(searchKey: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearch()
    }
    
}

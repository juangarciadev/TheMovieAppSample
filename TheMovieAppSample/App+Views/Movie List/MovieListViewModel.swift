//
//  MovieListViewModel.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/5/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation
import RxSwift

class MovieListViewModel: NSObject {
    
    lazy var searchController: UISearchController = {
        var temporarySC = UISearchController(searchResultsController: nil)
        temporarySC.searchResultsUpdater = self
        temporarySC.obscuresBackgroundDuringPresentation = false
        temporarySC.searchBar.placeholder = .search
        temporarySC.searchBar.tintColor = ThemeManager.Color.tintColor
        
        return temporarySC
    }()
    
    private let disposeBag = DisposeBag()
    
    let loading = Variable<Bool>(false)
    let movieResponse = Variable<MovieResponse?>(nil)
    let searchedMovieResponse = Variable<MovieResponse?>(nil)
    fileprivate var movies: [Movie]?
    fileprivate var searchedMovies: [Movie]?
    
    //TODO: Create ServerError class
    let error = PublishSubject<Error>()
    let defaultPage = 1
    
    func fetchMovies() {
        if isSearching() {
            searchMovies(for: searchController.searchBar.text, fetchEnabled: true)
        } else {
            getUpcomingMovies(fetchEnabled: true)
        }
    }
    
    func getUpcomingMovies(fetchEnabled: Bool = false) {
        guard !loading.value else {
            return
        }
        
        loading.value = true
        var nextPage = defaultPage
        if fetchEnabled, let movieResponse = movieResponse.value, let currentPage = movieResponse.page {
            nextPage = currentPage + 1
            if let totalPages = movieResponse.totalPages, nextPage > totalPages {
                // Couldn't load more pages
                loading.value = false
                return
            }
        }
        
        MoviesAPI.shared
            .getUpcoming(page: nextPage).subscribe(onNext: { [weak self] movieResponse in
                self?.loading.value = false
                
                if fetchEnabled {
                    guard let movies = movieResponse.results else {
                        return
                    }
                    self?.movies?.append(contentsOf: movies)
                } else {
                    self?.movies = movieResponse.results
                }
                
                self?.movieResponse.value = movieResponse
                }, onError: { [weak self] error in
                    self?.loading.value = false
                    self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func searchMovies(for searchText: String?, fetchEnabled: Bool = false) {
        guard let searchText = searchText,
            !searchText.isEmpty,
            !searchBarIsEmpty() else {
                searchedMovieResponse.value = nil
                searchedMovies = nil
                return
        }
        
        if fetchEnabled && loading.value {
            return
        }
        loading.value = true
        
        var nextPage = defaultPage
        if fetchEnabled, let searchedMovieResponse = searchedMovieResponse.value, let currentPage = searchedMovieResponse.page {
            nextPage = currentPage + 1
            if let totalPages = searchedMovieResponse.totalPages, nextPage > totalPages {
                // Couldn't load more pages
                return
            }
        }
        
        SearchAPI.shared
            .getMovies(for: searchText, page: nextPage).subscribe(onNext: { [weak self] movieResponse in
                self?.loading.value = false
                
                if fetchEnabled {
                    guard let movies = movieResponse.results else {
                        return
                    }
                    self?.searchedMovies?.append(contentsOf: movies)
                } else {
                    self?.searchedMovies = movieResponse.results
                }
                
                self?.searchedMovieResponse.value = movieResponse
                }, onError: { [weak self] error in
                    self?.loading.value = false
                    self?.error.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

// MARK: - Table view UI structure
extension MovieListViewModel {
    
    var sections: Int {
        return 1
    }
    
    var rows: Int {
        if isSearching() {
            return searchedMovies?.count ?? 0
        }
        
        return movies?.count ?? 0
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        let lastRow = (rows - 1)
        return indexPath.row == lastRow
    }
    
    func getMovie(at row: Int) -> Movie? {
        if isSearching() {
            guard let searchedMovie = searchedMovies, searchedMovie.count > row else {
                return nil
            }
            
            return searchedMovie[row]
        }
        
        guard let movies = movies, movies.count > row else {
            return nil
        }
        
        return movies[row]
    }
}

// MARK: - Search results updating delegate
extension MovieListViewModel: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchMovies(for: searchController.searchBar.text)
    }
}

fileprivate extension String {
    static let search = NSLocalizedString("Search", comment: "Title for search bar")
}

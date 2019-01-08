//
//  MovieListViewController.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/5/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import RxSwift

protocol MovieListViewControllerDelegate: class {
    func didSelect(_ movie: Movie)
}

class MovieListViewController: UITableViewController {
    
    weak var delegate: MovieListViewControllerDelegate? = nil
    let viewModel = MovieListViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        setupSearchController()
        addModelObservers()
        
        getUpcomingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView?.reloadEmptyDataSet()
    }
    
    // MARK: Get upcoming movies
    @objc func getUpcomingMovies() {
        viewModel.getUpcomingMovies()
    }
}

// MARK: Table view data source
extension MovieListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        if let movie = viewModel.getMovie(at: indexPath.row) {
            cell.render(movie)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if viewModel.loading.value || viewModel.rows == 0 {
            return nil
        }
        return .upcoming
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = ThemeManager.Font.headerTextFont
        header.textLabel?.textColor = ThemeManager.Color.tintColor
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
}

// MARK: - Table view delegate
extension MovieListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate,
            let movie = viewModel.getMovie(at: indexPath.row) {
            delegate.didSelect(movie)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - Table view data source prefetching
extension MovieListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoadingCell) {
           viewModel.fetchMovies()
        }
    }
}

// MARK: - View setup
extension MovieListViewController {
    
    func setupTableView() {
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        tableView.prefetchDataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = ThemeManager.Color.refreshControlTintColor
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: ThemeManager.Color.refreshControlTintColor,
            NSAttributedString.Key.font: ThemeManager.Font.refreshControlTitleFont!
        ]
        refreshControl?.attributedTitle = NSAttributedString(string: .pullToRefresh, attributes: attributes)
        refreshControl?.addTarget(self, action: #selector(getUpcomingMovies), for: .valueChanged)
    }
    
    func setupNavigationBar() {
        title = .movies
    }
    
    func setupSearchController() {
        navigationItem.searchController = viewModel.searchController
        definesPresentationContext = true
    }
    
    func addModelObservers() {
        viewModel.loading
            .asObservable()
            .subscribe(onNext: { [weak self] (isLoading) in
                if !isLoading {
                    self?.refreshControl?.endRefreshing()
                }
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        viewModel.movieResponse
            .asObservable()
            .subscribe(onNext: { [weak self] (movieResponse) in
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        viewModel.searchedMovieResponse
            .asObservable()
            .subscribe(onNext: { [weak self] (movieResponse) in
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        viewModel.error
            .asObservable()
            .subscribe(onNext: { [weak self] (error) in
                self?.refreshControl?.endRefreshing()
                self?.modalErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Empty view data source
extension MovieListViewController: EmptyDataSetSource {
        
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: ThemeManager.Font.emptyViewTitleFont!
        ]
        
        if viewModel.loading.value {
            return NSAttributedString(string: .loading, attributes: attributes)
        }
        return NSAttributedString(string: .noResults, attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -(topBarHeight)
    }
}

// MARK: - Action methods
extension MovieListViewController {
    
    @IBAction func unwindToPreviousVC(segue:UIStoryboardSegue) {}
}

fileprivate extension String {
    static let movies = NSLocalizedString("Movies", comment: "Title for navigation bar")
    static let upcoming = NSLocalizedString("Upcoming", comment: "Title for table header")
    static let pullToRefresh = NSLocalizedString("Pull To Refresh", comment: "Title for refresh control")
    static let noResults = NSLocalizedString("No Results", comment: "Title for empty view")
    static let loading = NSLocalizedString("Loading...", comment: "Title for empty view")
}

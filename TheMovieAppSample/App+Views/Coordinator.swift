//
//  Coordinator.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/5/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit

final class Coordinator {
    let splitViewController: UISplitViewController
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var movieListNavigationController: UINavigationController {
        return splitViewController.viewControllers.first as! UINavigationController
    }
    
    init(_ splitView: UISplitViewController) {
        self.splitViewController = splitView
        self.splitViewController.loadViewIfNeeded()
        
        let movieListVC = movieListNavigationController.viewControllers.first as! MovieListViewController
        movieListVC.delegate = self
    }
}

// MARK: - Movie list view controller delegate
extension Coordinator: MovieListViewControllerDelegate {
    
    func didSelect(_ movie: Movie) {
        let movieDetailNC = storyboard.instantiateMovieDetailNavigationController(with: movie, leftBarButtonItem: splitViewController.displayModeButtonItem)
        splitViewController.showDetailViewController(movieDetailNC, sender: self)
    }
}

// MARK: - Movie detail view controller delegate
extension Coordinator: MovieDetailViewControllerDelegate {
    
}

// MARK: - Storyboard helper methods
extension UIStoryboard {
    
    func instantiateMovieDetailNavigationController(with movie: Movie, leftBarButtonItem: UIBarButtonItem) -> UINavigationController {
        
        let movieDetailNC = instantiateViewController(withIdentifier: "movieDetailNavigationController") as! UINavigationController
        let movieDetailVC = movieDetailNC.viewControllers.first as! MovieDetailViewController
        movieDetailVC.viewModel.movie.value = movie
        movieDetailVC.navigationItem.leftBarButtonItem = leftBarButtonItem
        movieDetailVC.navigationItem.leftItemsSupplementBackButton = true
        
        return movieDetailNC
    }
}

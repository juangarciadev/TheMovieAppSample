//
//  MovieDetailViewController.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/5/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import RxSwift

protocol MovieDetailViewControllerDelegate: class {
    //func finishedRecording(_ recordVC: RecordViewController)
}

class MovieDetailViewController: UITableViewController {
    
    weak var delegate: MovieDetailViewControllerDelegate? = nil
    let viewModel = MovieDetailViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        addModelObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
         tableView?.reloadEmptyDataSet()
    }
}

// MARK: - Table view data source
extension MovieDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.getRowType(at: indexPath.row) {
        case .headerInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailHeaderCell", for: indexPath) as! MDHeaderTableViewCell
            if let movie = viewModel.movie.value {
                cell.render(movie)
            }
            
            return cell
        case .storyLine:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell", for: indexPath) as! MDTextTableViewCell
     
            let overview = viewModel.movie.value?.overview
            cell.render(withTitle: .storyLine, description: overview)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - View setup
extension MovieDetailViewController {
    
    func setupTableView() {
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
    }
    
    func addModelObservers() {
        viewModel.movie
            .asObservable()
            .subscribe(onNext: { [weak self] (movie) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Empty view data source
extension MovieDetailViewController: EmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "tickets_empty_view_icon")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: ThemeManager.Font.emptyViewTitleFont!
        ]
        return NSAttributedString(string: .emptyViewTitle, attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -(topBarHeight)
    }
}

fileprivate extension String {
    static let emptyViewTitle = NSLocalizedString("No Movie Selected", comment: "Title for empty table")
    static let storyLine = NSLocalizedString("Story Line", comment: "Title for text cell")
}

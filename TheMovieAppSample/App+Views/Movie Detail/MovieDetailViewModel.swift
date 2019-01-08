//
//  MovieDetailViewModel.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/5/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation
import RxSwift

class MovieDetailViewModel {
 
    private let disposeBag = DisposeBag()
    fileprivate let emptyTableCount = 0
    
    let movie = Variable<Movie?>(nil)
}

// MARK: - Table view UI structure
extension MovieDetailViewModel {
    
    enum DetailRowType: Int {
        case headerInfo = 0
        case storyLine
        case count
    }
    
    var sections: Int {
        return 1
    }
    
    var rows: Int {
        guard movie.value != nil else {
            return emptyTableCount
        }

        return DetailRowType.count.rawValue
    }
    
    func getRowType(at row: Int) -> DetailRowType {
        return DetailRowType.init(rawValue: row) ?? .headerInfo
    }
}

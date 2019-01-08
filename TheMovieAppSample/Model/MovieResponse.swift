//
//  MovieResponse.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]?
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let dates: UpcomingMovieDates?
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case dates
    }
}

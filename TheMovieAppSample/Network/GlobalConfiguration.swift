//
//  GlobalConfiguration.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation

struct GlobalConfiguration {
    
    static var TMDbAPIKey: String? {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any], let key = dictionary["TMDbAPIKey"] as? String {
            return key
        }
        return nil
    }
    
    static let TMDbURLString = "https://api.themoviedb.org/3"
    static let MovieUpcomingURLString = "\(TMDbURLString)/movie/upcoming"
    static let MovieURLString = "\(TMDbURLString)/movie"
    static let SearchMovieURLString = "\(TMDbURLString)/search/movie"
    static let TMDbAssetURLString = "https://image.tmdb.org/t/p"
    
    static let AppIdQueryParameter = "api_key"
    static let LanguageQueryParameter = "language"
    static let PageQueryParameter = "page"
    static let RegionQueryParameter = "region"
    static let AppendToResponseQueryParameter = "append_to_response"
    static let MovieIdQueryParameter = "movie_id"
    static let TextQueryParameter = "query"
    static let IncludeAdultQueryParameter = "include_adult"
    static let YearQueryParameter = "year"
    static let PrimaryReleaseYear = "primary_release_year"
}

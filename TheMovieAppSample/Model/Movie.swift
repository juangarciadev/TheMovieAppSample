//
//  Movie.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let voteCount: Int?
    let id: Int?
    let video: Bool?
    let voteAverage: Double?
    let title: String?
    let popularity: Double?
    let posterPath: String?
    let originalLanguage: String?
    let originalTitle: String?
    let genreIds: [Int]?
    let backdropPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDateString: String?
    let budget: Int?
    let homepage: String?
    let imdbId: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let belongsToCollection: BelongsToCollection?
    let genres: [Genres]?
    let productionCompanies: [ProductionCompanies]?
    let productionCountries: [ProductionCountries]?
    let spokenLanguages: [SpokenLanguages]?

    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id
        case video
        case voteAverage = "vote_average"
        case title
        case popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult
        case overview
        case releaseDateString = "release_date"
        case budget
        case homepage
        case imdbId = "imdb_id"
        case revenue
        case runtime
        case status
        case tagline
        case belongsToCollection = "belongs_to_collection"
        case genres
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
    }

    var releaseYear: Int? {
        guard let releaseDateString = releaseDateString else {
            return nil
        }
    
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        guard let releaseDate = dateFormater.date(from: releaseDateString) else {
            return nil
        }
        
        let calendar = Calendar.current
        return calendar.component(.year, from: releaseDate)
    }
    
    enum ImageSize: Int {
        case Small = 0
        case Medium = 1
        case Large = 2
    }
    
    func posterPathURL(size: ImageSize) -> URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        
        switch size {
        case .Small:
            return URL(string: "\(GlobalConfiguration.TMDbAssetURLString)/w185\(posterPath)")
        default:
            return URL(string: "\(GlobalConfiguration.TMDbAssetURLString)/w500\(posterPath)")
        }
    }
    
    func backdropPathURL(size: ImageSize) -> URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }
        
        switch size {
        case .Small:
            return URL(string: "\(GlobalConfiguration.TMDbAssetURLString)/w185\(backdropPath)")
        default:
            return URL(string: "\(GlobalConfiguration.TMDbAssetURLString)/w500\(backdropPath)")
        }
    }
}

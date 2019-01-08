//
//  BelongsToCollection.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation

struct BelongsToCollection: Codable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

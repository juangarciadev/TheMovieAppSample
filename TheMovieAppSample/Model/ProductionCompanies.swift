//
//  ProductionCompanies.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import Foundation

struct ProductionCompanies: Codable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

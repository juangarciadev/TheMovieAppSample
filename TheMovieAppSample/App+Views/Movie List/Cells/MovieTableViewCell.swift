//
//  MovieTableViewCell.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/5/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var yearLabel: UILabel!
    @IBOutlet private var rateLabel: UILabel!
    @IBOutlet private var overviewLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func render(_ movie: Movie) {
        titleLabel.text = movie.title ?? .unknownName
        
        if let releaseYear = movie.releaseYear {
            yearLabel.text = String(releaseYear)
            yearLabel.isHidden = false
        } else {
           yearLabel.isHidden = true
        }
        if let voteAverage = movie.voteAverage {
            rateLabel.text = String(voteAverage)
            
            let highRatingBackgroundColor = ThemeManager.Color.highRatingBackgroundColor
            let lowRatingBackgroundColor = ThemeManager.Color.lowRatingBackgroundColor
            rateLabel.backgroundColor = voteAverage > 5 ? highRatingBackgroundColor : lowRatingBackgroundColor
            rateLabel.textColor = voteAverage > 5 ? .black : .white
            rateLabel.isHidden = false
        } else {
            rateLabel.isHidden = true
        }
        if let overview = movie.overview {
            overviewLabel.text = overview
            overviewLabel.isHidden = false
        } else {
            overviewLabel.isHidden = true
        }
        if let posterPathURL = movie.posterPathURL(size: .Small) {
            posterImageView.setImage(with: posterPathURL)
        } else {
            posterImageView.image = nil
        }
    }
}

fileprivate extension String {
    static let unknownName = "Unknown Name"
}

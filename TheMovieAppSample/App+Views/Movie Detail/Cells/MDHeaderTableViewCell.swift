//
//  MDHeaderTableViewCell.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/8/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit

class MDHeaderTableViewCell: UITableViewCell {

    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var yearLabel: UILabel!
    @IBOutlet private var rateLabel: UILabel!
    
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
        if let smallPosterPathURL = movie.posterPathURL(size: .Small) {
            posterImageView.setImage(with: smallPosterPathURL)
        } else {
            posterImageView.image = nil
        }
        
        if let largeBackdropPathURL = movie.backdropPathURL(size: .Large) {
            backgroundImageView.setImage(with: largeBackdropPathURL)
        } else {
            backgroundImageView.image = nil
        }
    }
}

fileprivate extension String {
    static let unknownName = "Unknown Name"
}

//
//  MDTextTableViewCell.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/8/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit

class MDTextTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func render(withTitle title: String, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

//
//  UIImageView+Extensions.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/6/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    /**
     Set an image with a downloadURL, a placeholder image.
     
     - parameter downloadURL: Resource object contains downloadURL information.
     - parameter placeholder: A placeholder image when retrieving the image at URL.
     */
    func setImage(with downloadURL: URL, placeholder: UIImage? = nil) {
        self.kf.setImage(with: downloadURL, placeholder: placeholder)
    }
}



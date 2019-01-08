//
//  UIViewController+Extensions.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/7/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Height of status bar + navigation bar (if navigation bar exist)
    var topBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (navigationController?.navigationBar.frame.height ?? 0)
    }
    
    func modalErrorAlert(title: String = .cannotGetWeather,
                         message: String? = nil,
                         accept: String = .ok,
                         callback: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: accept, style: .default) { _ in
            if let callback = callback {
                callback()
            }
        })
        present(alert, animated: true)
    }
}

fileprivate extension String {
    static let cannotGetWeather = NSLocalizedString("Cannot Get Weather", comment: "Title for error alert")
    static let ok = NSLocalizedString("OK", comment: "")
}

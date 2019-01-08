//
//  ThemeManager.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/5/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit

protocol ThemeColor {
    static var tintColor: UIColor { get }
    static var barStyle: UIBarStyle { get }
    static var keyboardAppearance: UIKeyboardAppearance { get }
    static var backgroundColor: UIColor { get }
    static var secondaryBackgroundColor: UIColor { get }
    static var negativeBackgroundColor: UIColor { get }
    static var titleTextColor: UIColor { get }
}

protocol ThemeFont {
    static var headerTextFont: UIFont? { get }
}

struct ThemeManager {
    
    struct Color: ThemeColor {
        
        static var tintColor: UIColor {
            return .white
        }
        
        static var barStyle: UIBarStyle {
            return UIBarStyle.black
        }
        
        static var keyboardAppearance: UIKeyboardAppearance {
            return UIKeyboardAppearance.default
        }
        
        static var backgroundColor: UIColor {
            return #colorLiteral(red: 0.1295526326, green: 0.1406245232, blue: 0.1408458054, alpha: 1)
        }
        
        static var secondaryBackgroundColor: UIColor {
            return #colorLiteral(red: 0.1773745716, green: 0.1925856173, blue: 0.1879937649, alpha: 1)
        }
        
        static var negativeBackgroundColor: UIColor {
            return #colorLiteral(red: 0.1295526326, green: 0.1406245232, blue: 0.1408458054, alpha: 1)
        }
        
        static var titleTextColor: UIColor {
            return .white
        }
        
        static var highRatingBackgroundColor: UIColor {
            return #colorLiteral(red: 0.959268868, green: 0.800019443, blue: 0.2208219171, alpha: 1)
        }
        
        static var lowRatingBackgroundColor: UIColor {
            return #colorLiteral(red: 0.1536991894, green: 0.7172269225, blue: 0.4517918825, alpha: 1)
        }
        
        static var refreshControlTintColor: UIColor {
            return .white
        }
    }
    
    struct Font: ThemeFont {
        
        static func helveticaBoldFont(withSize fontSize: CGFloat) -> UIFont? {
            return UIFont(name: "Helvetica-Bold", size: fontSize)
        }
        
        static func helveticaRegularFont(withSize fontSize: CGFloat) -> UIFont? {
            return UIFont(name: "Helvetica", size: fontSize)
        }
        
        static var headerTextFont: UIFont? {
            return helveticaBoldFont(withSize: 17)
        }
        
        static var refreshControlTitleFont: UIFont? {
            return helveticaBoldFont(withSize: 12)
        }
        
        static var emptyViewTitleFont: UIFont? {
            return helveticaBoldFont(withSize: 17)
        }
    }
}

//
//  AppDelegate.swift
//  TheMovieAppSample
//
//  Created by Juan Garcia on 1/5/19.
//  Copyright © 2019 Juan Garcia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var coordinator: Coordinator? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let splitViewController = window!.rootViewController as! RootViewController
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = .allVisible
        coordinator = Coordinator(splitViewController)
        
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let topAsDetailController = (secondaryViewController as? UINavigationController)?.topViewController as? MovieDetailViewController else { return false }
        if topAsDetailController.viewModel.movie.value == nil {
            // Don't include an empty player in the navigation stack when collapsed
            return true
        }
        return false
    }
}


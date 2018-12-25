//
//  MoviesTabBarController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class MoviesTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storageManager = MovieStorage()

        let watchlistVC = MoviesViewController.instantiate()
        watchlistVC.category = .watchlist
        watchlistVC.tabBarItem = UITabBarItem(title: String.watchlist,
                                              image: MovieListCategory.watchlist.image,
                                              tag: 0)
        watchlistVC.tabBarItem.accessibilityIdentifier = "WatchlistTab"
        watchlistVC.storageManager = storageManager
        let watchlistVCWithNavi = OrangeNavigationController(rootViewController: watchlistVC)

        let seenVC = MoviesViewController.instantiate()
        seenVC.category = .seen
        seenVC.tabBarItem = UITabBarItem(title: String.seen,
                                         image: MovieListCategory.seen.image,
                                         tag: 1)
        seenVC.tabBarItem.accessibilityIdentifier = "SeenTab"
        seenVC.storageManager = storageManager
        let seenVCWithNavi = OrangeNavigationController(rootViewController: seenVC)

        let settingsVC = SettingsViewController.instantiate()
        settingsVC.tabBarItem = UITabBarItem(title: String.settingsTitle,
                                             image: UIImage.settingsIcon,
                                             tag: 2)
        settingsVC.tabBarItem.accessibilityIdentifier = "SettingsTab"
        let settingsVCWithNavi = OrangeNavigationController(rootViewController: settingsVC)

        viewControllers = [watchlistVCWithNavi, seenVCWithNavi, settingsVCWithNavi]
    }
}

extension MoviesTabBarController: Instantiable {
    static var storyboard: Storyboard { return .main }
    static var storyboardID: String? { return "MoviesTabBarController" }
}

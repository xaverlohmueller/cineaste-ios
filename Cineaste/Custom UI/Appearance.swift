//
//  Appearance.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 26.12.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import UIKit

enum Appearance {
    static func setup() {
        // MARK: TabBar
        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.tintColor = .basicWhite
        tabBar.barTintColor = .primaryOrange
        tabBar.unselectedItemTintColor = .basicBackground

        // MARK: TabBarItem
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([
            .foregroundColor: UIColor.basicWhite
            ], for: .selected)
        tabBarItem.setTitleTextAttributes([
            .foregroundColor: UIColor.basicBackground
            ], for: .normal)

        // MARK: SearchBar
        let searchBar = UISearchBar.appearance()
        searchBar.tintColor = .basicWhite
        searchBar.barTintColor = .primaryOrange

        //change color of cursor
        let searchField = UITextField
            .appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchField.tintColor = .basicBackground

        // MARK: UIAlertController
        //change tint color in UIAlertController
        let alertController = UIView
            .appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertController.tintColor = .primaryOrange
    }
}

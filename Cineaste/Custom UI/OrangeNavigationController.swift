//
//  NavigationViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 09.04.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class OrangeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .basicWhite

        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .primaryOrange
        navigationBar.tintColor = .basicWhite
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.basicWhite
        ]

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
            navigationBar.prefersLargeTitles = true
            navigationBar.largeTitleTextAttributes = [
                .foregroundColor: UIColor.basicWhite
            ]
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

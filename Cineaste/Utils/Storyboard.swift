//
//  Storyboard.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case movieList = "MoviesList"
    case search = "Search"
    case movieDetail = "MovieDetail"
    case settings = "Settings"
    case movieNight = "MovieNight"
}

extension Storyboard {
    func load() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
}

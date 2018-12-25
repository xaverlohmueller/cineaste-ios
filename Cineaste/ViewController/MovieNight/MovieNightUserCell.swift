//
//  MovieNightUserTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class MovieNightUserCell: UITableViewCell {
    static let identifier = "MovieNightUserTableViewCell"

    @IBOutlet private weak var allTitle: TitleLabel!
    @IBOutlet private weak var namesOfFriendsLabel: DescriptionLabel!
    @IBOutlet private weak var numberOfMoviesLabel: DescriptionLabel!

    func configureAll(numberOfMovies: Int, namesOfFriends: [String]) {
        setup()

        allTitle.text = String.allResultsForMovieNight
        numberOfMoviesLabel.text = String.movies(for: numberOfMovies)

        namesOfFriendsLabel.isHidden = false
        namesOfFriendsLabel.text = namesOfFriends.joined(separator: ", ")
    }

    func configure(userName: String, numberOfMovies: Int) {
        setup()

        allTitle.text = userName
        numberOfMoviesLabel.text = String.movies(for: numberOfMovies)

        namesOfFriendsLabel.isHidden = true
    }

    private func setup() {
        accessoryType = .disclosureIndicator
    }
}

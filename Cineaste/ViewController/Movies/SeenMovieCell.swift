//
//  SeenMovieCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 12.05.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class SeenMovieCell: MovieListCell {
    @IBOutlet weak var watched: DescriptionLabel!
    @IBOutlet weak var watchedIcon: UIImageView! {
        didSet {
            watchedIcon.tintColor = UIColor.accentTextOnWhite
        }
    }

    override func configure(for movie: StoredMovie) {
        super.configure(for: movie)

        title.text = movie.title
        watched.text = movie.formattedWatchedDate
    }
}

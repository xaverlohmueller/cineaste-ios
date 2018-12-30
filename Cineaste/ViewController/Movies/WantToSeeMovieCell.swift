//
//  WantToSeeMovieCell.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 29.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

class WantToSeeMovieCell: MovieListCell {

    @IBOutlet weak var votes: DescriptionLabel!
    @IBOutlet weak var runtime: DescriptionLabel!
    @IBOutlet weak var releaseDate: DescriptionLabel!

    override func configure(for movie: StoredMovie) {
        super.configure(for: movie)

        title.text = movie.title
        votes.text = movie.formattedVoteAverage
        runtime.text = movie.formattedRuntime
        releaseDate.text = movie.formattedReleaseDate
    }
}

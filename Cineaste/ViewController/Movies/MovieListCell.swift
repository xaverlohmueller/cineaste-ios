//
//  MovieListCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 06.12.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell, ConfiguringCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: TitleLabel!
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .primaryOrange
        }
    }

    @IBOutlet weak var votes: DescriptionLabel!
    @IBOutlet weak var runtime: DescriptionLabel!
    @IBOutlet weak var releaseDate: DescriptionLabel!

    func configure(for movie: StoredMovie) {
        if let moviePoster = movie.poster {
            poster.image = UIImage(data: moviePoster)
        } else {
            poster.image = UIImage.posterPlaceholder
        }

        title.text = movie.title
        votes.text = movie.formattedVoteAverage
        runtime.text = movie.formattedRuntime
        releaseDate.text = movie.formattedReleaseDate
    }
}

//
//  Movie+Formatted.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

extension Movie {
    var formattedVoteAverage: String {
        if voteCount != 0 && voteAverage != 0 {
            return voteAverage.formattedWithOneFractionDigit
                ?? String.unknownVoteAverage
        } else {
            return String.unknownVoteAverage
        }
    }

    var formattedReleaseDate: String {
        if let release = releaseDate {
            return release.formatted
        } else {
            return String.unknownReleaseDate
        }
    }

    var formattedRuntime: String {
        if runtime != 0 {
            return "\(runtime.formatted ?? String.unknownRuntime) min"
        } else {
            return "\(String.unknownRuntime) min"
        }
    }
}

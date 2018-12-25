//
//  SearchMoviesViewController+Webservice.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController {

    func loadDetails(for movie: Movie, completionHandler completion: @escaping (Movie?) -> Void) {
        Webservice.load(resource: movie.get) { result in
            switch result {
            case .error:
                self.showAlert(withMessage: Alert.loadingDataError)
                completion(nil)
            case .success(let detailedMovie):
                detailedMovie.poster = movie.poster
                completion(detailedMovie)
            }
        }
    }
}

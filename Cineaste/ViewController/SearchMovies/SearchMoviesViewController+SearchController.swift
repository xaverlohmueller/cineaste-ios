//
//  SearchMoviesViewController+SearchController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }

        movieSearchController.searchMovies(text) { [weak self] result in
            guard let self = self else { return }

            guard let value = result.value else {
                self.showAlert(withMessage: Alert.loadingDataError)
                self.movies = []
                return
            }

            self.movies = value
            self.scrollToTopCell(withAnimation: true)
        }
    }
}

extension SearchMoviesViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        searchDelayTimer?.invalidate()
        searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.movieSearchController.searchMovies(searchController.searchBar.text) { movies in
                self?.movies = movies.value ?? []
                self?.scrollToTopCell(withAnimation: false)
            }
        }
    }
}

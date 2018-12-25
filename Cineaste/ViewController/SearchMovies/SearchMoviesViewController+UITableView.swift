//
//  SearchMoviesViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SearchMoviesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            indexPaths.first(where: { $0.isLast(of: movies.count) }) != nil
            else { return }

        if movieSearchController.canLoadMoreMovies && !isLoadingNextPage {
            tableView.tableFooterView = loadingIndicatorView
            isLoadingNextPage = true

            movieSearchController.searchNextPage { [weak self] result in
                self?.isLoadingNextPage = false
                self?.movies += result.value ?? []
            }
        }
    }
}

extension SearchMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        perform(segue: .showMovieDetail, sender: self)
    }
}

extension SearchMoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchMoviesCell = tableView.dequeueCell(identifier: SearchMoviesCell.identifier)
        cell.movie = movies[indexPath.row]

        if indexPath.isLast(of: movies.count) {
            tableView.tableFooterView = UIView()
        }

        cell.delegate = self
        return cell
    }
}

//
//  MovieSearchController.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 25.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

final class MovieSearchController {
    private var page = 1
    private var totalPages = 0

    private var query: String? {
        didSet {
            page = 1
            totalPages = 0
        }
    }

    var canLoadMoreMovies: Bool {
        return page < totalPages
    }

    func searchMovies(_ query: String? = nil, completion: @escaping Completion<[Movie]>) {
        self.query = query

        Webservice.searchMovies(query, page: page) { [weak self] result in
            self?.handle(result: result, completion: completion)
        }
    }

    func searchNextPage(completion: @escaping Completion<[Movie]>) {
        Webservice.searchMovies(query, page: page + 1) { [weak self] result in
            self?.handle(result: result, completion: completion)
        }
    }

    private func handle(result: Result<PagedMovieResult>, completion: @escaping Completion<[Movie]>) {
        switch result {
        case .success(let value):
            self.page = value.page
            self.totalPages = value.totalPages
            completion(.success(value.results))
        case .error(let error):
            completion(.error(error))
        }
    }
}

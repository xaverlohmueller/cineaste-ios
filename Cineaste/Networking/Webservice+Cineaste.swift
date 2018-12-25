//
//  Webservice+Cineaste.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 25.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

extension Webservice {
    static func searchMovies(_ query: String?, page: Int, completion: @escaping Completion<PagedMovieResult>) {
        let resource = Movie.search(withQuery: query, page: page)
        Webservice.load(resource: resource, completion: completion)
    }

    static func loadDetails(_ id: String, completion: @escaping Completion<Movie>) {

    }
}

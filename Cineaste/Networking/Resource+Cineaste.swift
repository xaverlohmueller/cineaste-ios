//
//  Resource+Cineaste.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 25.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

extension Resource {
    static func loadMovie(by id: Int64) -> Resource<Movie> {
        let url = "\(Constants.Backend.url)/movie/\(id)"

        let query = ["append_to_response": "release_dates"]

        return Resource<Movie>(url: url, query: query) { data in
            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(Movie.self, from: data)

                let release = try? decoder.decode(LocalizedReleaseDate.self,
                                                  from: data)
                movie.releaseDate = release?.date

                return movie
            } catch {
                print(error)
                return nil
            }
        }
    }
}

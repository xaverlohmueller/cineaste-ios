//
//  StoredMovie.swift
//  Cineaste
//
//  Created by Christian Braun on 05.11.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import UIKit
import CoreData

enum StoredMovieDecodingError: Error {
    case dateFromString
    case entityCreation
    case findContext
}

extension CodingUserInfoKey {
    //swiftlint:disable:next force_unwrapping
    static let context = CodingUserInfoKey(rawValue: "context")!
}

@objc(StoredMovie)
class StoredMovie: NSManagedObject, Codable {

    static func saveMovie(_ movie: Movie, in context: NSManagedObjectContext) -> StoredMovie {
        let stored: StoredMovie = context.insertObject()
        stored.id = movie.id
        stored.title = movie.title
        stored.overview = movie.overview
        stored.posterPath = movie.posterPath

        if let moviePoster = movie.poster {
            stored.poster = moviePoster.jpegData(compressionQuality: 1)
        }

        stored.voteAverage = movie.voteAverage
        stored.voteCount = movie.voteCount

        stored.runtime = movie.runtime
        stored.releaseDate = movie.releaseDate

        stored.watched = false
        stored.watchedDate = nil

        stored.listPosition = 0

        return stored
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"

        case voteAverage = "vote_average"
        case voteCount = "vote_count"

        case runtime
        case releaseDate = "release_date"

        case watched
        case watchedDate

        case listPosition
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            throw StoredMovieDecodingError.findContext
        }

        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else {
            throw StoredMovieDecodingError.entityCreation
        }

        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)

        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        voteCount = try container.decode(Double.self, forKey: .voteCount)
        runtime = try container.decode(Int16.self, forKey: .runtime)

        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            guard let releaseDate = releaseDateString.dateFromImportedMoviesString else {
                throw StoredMovieDecodingError.dateFromString
            }
            self.releaseDate = releaseDate
        }

        watched = try container.decode(Bool.self, forKey: .watched)

        if let watchedDateString = try container.decodeIfPresent(String.self, forKey: .watchedDate) {
            guard let watchedDate = watchedDateString.dateFromImportedMoviesString else {
                throw StoredMovieDecodingError.dateFromString
            }
            self.watchedDate = watchedDate
        }

        listPosition = try container.decode(Int16.self, forKey: .listPosition)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(overview, forKey: .overview)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)

        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(voteCount, forKey: .voteCount)

        try container.encode(runtime, forKey: .runtime)
        try container.encodeIfPresent(releaseDate?.formattedForJson, forKey: .releaseDate)

        try container.encode(watched, forKey: .watched)
        try container.encodeIfPresent(watchedDate?.formattedForJson, forKey: .watchedDate)

        try container.encode(listPosition, forKey: .listPosition)
    }
}

extension StoredMovie: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "listPosition", ascending: true),
            NSSortDescriptor(key: "title", ascending: true)
        ]
    }
    static var seenMoviesSortDescriptors: [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "watchedDate", ascending: false)
        ]
    }
}

//
//  MovieStorageManager.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 28.12.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import UIKit
import CoreData

class MovieStorage {
    let persistentContainer: NSPersistentContainer

    // MARK: Init with dependency
    init(container: NSPersistentContainer = AppDelegate.persistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    // MARK: CRUD
    //swiftlint:disable:next function_parameter_count
    func insertMovieItem(id: Int64,
                         overview: String,
                         poster: Data?,
                         posterPath: String,
                         releaseDate: Date,
                         runtime: Int16,
                         title: String,
                         voteAverage: Double,
                         voteCount: Double,
                         watched: Bool,
                         handler: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let storedMovie = StoredMovie(context: self.backgroundContext)
            storedMovie.id = id
            storedMovie.title = title
            storedMovie.overview = overview

            storedMovie.posterPath = posterPath
            storedMovie.poster = poster

            storedMovie.releaseDate = releaseDate
            storedMovie.runtime = runtime
            storedMovie.voteAverage = voteAverage
            storedMovie.voteCount = voteCount

            storedMovie.watched = watched
            storedMovie.watchedDate = watched ? Date() : nil
            self.save(handler: handler)
        }
    }

    func insertMovieItem(with movie: Movie,
                         watched: Bool,
                         handler: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let storedMovie = StoredMovie(context: self.backgroundContext)
            storedMovie.id = movie.id
            storedMovie.title = movie.title
            storedMovie.overview = movie.overview

            storedMovie.posterPath = movie.posterPath
            if let moviePoster = movie.poster {
                storedMovie.poster = moviePoster.jpegData(compressionQuality: 1)
            }

            storedMovie.releaseDate = movie.releaseDate
            storedMovie.runtime = movie.runtime
            storedMovie.voteAverage = movie.voteAverage
            storedMovie.voteCount = movie.voteCount

            storedMovie.watched = watched
            storedMovie.watchedDate = watched ? Date() : nil
            self.save(handler: handler)
        }
    }

    func updateMovieItem(with movie: StoredMovie,
                         watched: Bool,
                         handler: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let storedMovie = StoredMovie(context: self.backgroundContext)
            storedMovie.id = movie.id
            storedMovie.title = movie.title
            storedMovie.overview = movie.overview

            storedMovie.posterPath = movie.posterPath
            storedMovie.poster = movie.poster

            storedMovie.releaseDate = movie.releaseDate
            storedMovie.runtime = movie.runtime
            storedMovie.voteAverage = movie.voteAverage
            storedMovie.voteCount = movie.voteCount

            storedMovie.watched = watched
            storedMovie.watchedDate = watched ? Date() : nil
            self.save(handler: handler)
        }
    }

    /// Must be called on main thread because of core data view context
    func fetchAll() -> [StoredMovie] {
        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? []
    }

    /// Must be called on main thread because of core data view context
    func fetchAllWatchlistMovies() -> [StoredMovie] {
        let request: NSFetchRequest<StoredMovie> = StoredMovie.fetchRequest()
        request.predicate = MovieListCategory.watchlist.predicate
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? []
    }

    func resetCoreData(completion: @escaping (Error?) -> Void) {
        backgroundContext.perform {
            do {
                let entities: [StoredMovie] = try self.backgroundContext
                    .fetch(StoredMovie.fetchRequest())
                for entity in entities {
                    self.backgroundContext.delete(entity)
                }
                try self.backgroundContext.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    func remove(_ storedMovie: StoredMovie,
                handler: ((_ result: Result<Bool>) -> Void)? = nil) {
        backgroundContext.perform {
            let object = self.backgroundContext.object(with: storedMovie.objectID)
            self.backgroundContext.delete(object)
            self.save(handler: handler)
        }
    }

    fileprivate func save(handler: ((_ result: Result<Bool>) -> Void)? = nil) {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
                handler?(.success(true))
            } catch {
                print("Save error \(error)")
                handler?(.error(error))
            }
        }
    }
}

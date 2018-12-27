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

    func insertMovieItem(with movie: Movie,
                         watched: Bool,
                         handler: Completion<Void>? = nil) {
        backgroundContext.performChanges { context in

            let storedMovie = StoredMovie.saveMovie(movie, in: context)
            storedMovie.watched = watched
            storedMovie.watchedDate = watched ? Date() : nil
            handler?(.success(()))
        }
    }

    func updateMovieItem(with movie: StoredMovie,
                         watched: Bool,
                         handler: Completion<Void>? = nil) {
        let context = movie.managedObjectContext ?? backgroundContext
        context.performChanges { _ in
            movie.watched = watched
            movie.watchedDate = watched ? Date() : nil
            handler?(.success(()))
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
        backgroundContext.performChanges { context in
            let entities: [StoredMovie] = try context.fetch(StoredMovie.fetchRequest())
            for entity in entities {
                context.delete(entity)
            }
            completion(nil)
        }
    }

    func remove(_ storedMovie: StoredMovie,
                handler: Completion<Void>? = nil) {
        let context = storedMovie.managedObjectContext ?? backgroundContext
        context.performChanges { context in
            let object = context.object(with: storedMovie.objectID)
            context.delete(object)
            handler?(.success(()))
        }
    }
}

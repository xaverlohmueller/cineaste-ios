//
//  CoreDataPersistence.swift
//  Cineaste App-Dev
//
//  Created by Xaver Lohmüller on 10.10.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import CoreData

final class CoreDataPersistence: Persistence {

    private let container: NSPersistentContainer = {
        $0.viewContext.automaticallyMergesChangesFromParent = true
        $0.loadPersistentStores(completionHandler: { _, error in
            if let error = error { print(error as NSError) }
        })

        return $0
    }(NSPersistentContainer(name: "Model"))

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.container.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    init() {}

    func insert(movie: Movie) throws {
        let context = container.viewContext
        let coreDataMovie = StoredMovie(withMovie: movie, context: context)
        context.insert(coreDataMovie)
        try context.save()
    }

    func update(movie: Movie) throws {
        fatalError()
    }

    func delete(movie: Movie) throws {
        fatalError()
    }

    func readAll() throws -> [StoredMovie] {
        return try container.viewContext.fetch(StoredMovie.fetchRequest())
    }

    func clear() throws {
        fatalError()
    }

    func exportDatabase() -> Data {
        fatalError()
    }

    func importDatabase(data: Data) {
        fatalError()
    }
}

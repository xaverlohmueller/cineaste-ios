//
//  FileImporter.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 25.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

enum ImportError: Error {
    case noDataAtPath
    case parsingJsonToStoredMovie
}

enum Importer {
    static func importMovies(from path: URL, storageManager: MovieStorageManager, completion: @escaping ((Result<Int>) -> Void)) {
        Importer.decodeMovies(from: path, with: storageManager) { result in
            switch result {
            case .error(let error):
                completion(.error(error))
            case .success(let movies):
                Importer.save(movies, with: storageManager, completion: completion)
            }
        }
    }
}

extension Importer {
    private static func decodeMovies(from path: URL, with storageManager: MovieStorageManager, completion: @escaping ((Result<[StoredMovie]>) -> Void)) {
        guard let data = try? Data(contentsOf: path, options: []) else {
            completion(.error(ImportError.noDataAtPath))
            return
        }

        storageManager.backgroundContext.performChanges {
            do {
                let decoder = JSONDecoder()
                decoder.userInfo[.context] = storageManager.backgroundContext

                let importExportObject = try decoder.decode(ImportExportObject.self,
                                                            from: data)
                completion(.success(importExportObject.movies))
            } catch {
                completion(.error(ImportError.parsingJsonToStoredMovie))
            }
        }
    }

    private static func save(_ movies: [StoredMovie], with storageManager: MovieStorageManager, completion: @escaping ((Result<Int>) -> Void)) {
        let dispatchGroup = DispatchGroup()

        storageManager.backgroundContext.performChanges {
            //load all posters
            for movie in movies {
                dispatchGroup.enter()

                movie.reloadPosterIfNeeded {
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.wait()
            DispatchQueue.main.async {
                completion(.success(movies.count))
            }
        }
    }
}

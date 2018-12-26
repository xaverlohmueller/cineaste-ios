//
//  Persistence.swift
//  Cineaste App-Dev
//
//  Created by Xaver Lohmüller on 10.10.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

protocol Persistence {
    func insert(movie: Movie) throws
    func update(movie: Movie) throws
    func delete(movie: Movie) throws

    func readAll() throws -> [StoredMovie]
    func clear() throws

    func exportDatabase() -> Data
    func importDatabase(data: Data)
}

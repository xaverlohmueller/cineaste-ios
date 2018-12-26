//
//  World.swift
//  Cineaste App-Dev
//
//  Created by Xaver Lohmüller on 10.10.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

struct World {
    var persistence: Persistence = CoreDataPersistence()
}

// swiftlint:disable:next identifier_name
var Current = World()

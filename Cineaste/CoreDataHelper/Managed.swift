//
//  Managed.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 27.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import CoreData

protocol Managed: AnyObject, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }

    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name ?? ""
    }
}

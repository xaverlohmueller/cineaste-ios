//
//  NSManagedObjectContext+Extensions.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 27.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A
            else { fatalError("Wrong object type") }
        return obj
    }

    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }

    func performChanges(block: @escaping (NSManagedObjectContext) throws -> Void) {
        perform {
            do {
                try block(self)
                _ = self.saveOrRollback()
            } catch {
                self.rollback()
            }
        }
    }
}

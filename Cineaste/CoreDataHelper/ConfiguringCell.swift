//
//  ConfiguringCell.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 28.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit
import CoreData

protocol ConfiguringCell {
    static var identifier: String { get }

    associatedtype Object: NSFetchRequestResult
    func configure(for object: Object)
}

extension ConfiguringCell where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

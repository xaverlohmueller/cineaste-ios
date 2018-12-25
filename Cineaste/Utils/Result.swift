//
//  Either.swift
//  Cineaste
//
//  Created by Christian Braun on 27.01.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

enum Result<SuccessType> {
    case success(SuccessType)
    case error(Error)
}

extension Result {
    var value: SuccessType? {
        if case let .success(value) = self {
            return value
        } else {
            return nil
        }
    }

    var error: Error? {
        if case let .error(error) = self {
            return error
        } else {
            return nil
        }
    }
}

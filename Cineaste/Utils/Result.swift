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

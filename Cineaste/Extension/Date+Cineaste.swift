//
//  Date+Cineaste.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 26.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

extension Date {
    var oneMonthInThePast: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self) ?? Date()
    }
    var oneMonthInTheFuture: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self) ?? Date()
    }
}

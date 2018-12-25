//
//  String+DateFormatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import UIKit

extension String {
    private static let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        if #available(iOS 11.0, *) {
            formatter.formatOptions = [.withInternetDateTime,
                                       .withFractionalSeconds]
        } else {
            formatter.formatOptions = [.withInternetDateTime]
        }
        return formatter
    }()

    var dateFromString: Date? {
        String.dateFormatter.dateFormat = "yyyy-MM-dd"
        return String.dateFormatter.date(from: self)
    }

    var dateFromImportedMoviesString: Date? {
        String.dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        return String.dateFormatter.date(from: self)
    }

    var dateFromISO8601: Date? {
        return String.iso8601Formatter.date(from: self)
    }
}

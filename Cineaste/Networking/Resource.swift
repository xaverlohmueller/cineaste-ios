//
//  Resource.swift
//  Cineaste
//
//  Created by Christian Braun on 25.10.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

struct Resource<A> {
    let url: String
    let query: [String: String]
    let method: HTTPMethod
    let parse: (Data) -> A?

    init(url: String, query: [String: String] = [:], method: HTTPMethod = .get, parse: @escaping (Data) -> A?) {
        self.url = url
        self.query = query
        self.method = method
        self.parse = parse
    }
}

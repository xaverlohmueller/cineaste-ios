//
//  Webservice.swift
//  Cineaste
//
//  Created by Christian Braun on 25.10.17.
//  Copyright © 2017 spacepandas.de. All rights reserved.
//

import Foundation

typealias Completion<A> = (Result<A>) -> Void

enum NetworkError: Error {
    case parseUrl
    case parseJson
    case parseData
    case emptyResource
}

enum Webservice {
    @discardableResult
    static func load<A>(resource: Resource<A>?, completion: @escaping Completion<A>) -> URLSessionTask? {
        guard let resource = resource else {
            completion(.error(NetworkError.emptyResource))
            return nil
        }
        guard let url = URL(string: resource.url),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else {
                completion(.error(NetworkError.parseUrl))
                return nil
        }

        components.queryItems =
            components.queryItems ?? []
            + defaultQueryItems
            + resource.query.map(URLQueryItem.init)

        var request = URLRequest(url: components.url ?? url)
        request.httpMethod = resource.method.rawValue

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil, let data = data else {
                // swiftlint:disable:next force_unwrapping
                completion(.error(error!))
                return
            }
            guard let result = resource.parse(data) else {
                completion(.error(NetworkError.parseData))
                return
            }
            completion(.success(result))
        }

        task.resume()
        return task
    }

    private static let defaultQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "language", value: .languageFormattedForTMDb),
        URLQueryItem(name: "api_key", value: ApiKeyStore.theMovieDbKey)
    ]
}

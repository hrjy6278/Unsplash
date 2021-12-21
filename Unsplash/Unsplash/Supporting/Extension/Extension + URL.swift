//
//  Extension + URL.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/21.
//

import Foundation

extension URL {
    func appendingQueryParameters(_ parameters: [String: String]?) -> URL? {
        guard let parameters = parameters else { return nil }

        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)
        var queryItems = urlComponents?.queryItems ?? []

        queryItems += parameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents?.queryItems = queryItems

        return urlComponents?.url
    }
}

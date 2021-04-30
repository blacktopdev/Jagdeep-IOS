//
//  MockDataLoader.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/15/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MockDataRepository {

    enum LoaderError: Error {
        case fileNotFound
    }

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return decoder
    }

    static func loadDomain<D: DomainObject>(_ type: D.Type) throws -> D {
        print("Loading for \(type.entityName)")
        guard let url = Bundle.main.url(forResource: "json/\(type.entityName)",
                                        withExtension: "json") else {
            throw(LoaderError.fileNotFound)
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode(D.self, from: data)
    }

}

struct MockDataWebRepository {
    let session: URLSession
    let baseURL: String

}

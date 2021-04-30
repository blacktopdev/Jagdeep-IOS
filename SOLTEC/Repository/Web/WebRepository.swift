//
//  WebRepository.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/19/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation
import Combine

//protocol WebDecoder {
//    associatedtype Decoded
//
//    var decoder: JSONDecoder { get }
//}

protocol WebRepository {
    var baseUrl: String { get }
    var session: URLSession { get }
//    var decoder: WebDecoder { get }
    var decoder: JSONDecoder { get }
//    var bgQueue: DispatchQueue { get }
}

extension WebRepository {
    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error>
        where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseUrl)
            return session
                .dataTaskPublisher(for: request)
                .extractJSON(httpCodes: httpCodes, decoder: decoder)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
}

// MARK: - Helpers

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func extractJSON<Value>(httpCodes: HTTPCodes, decoder: JSONDecoder) -> AnyPublisher<Value, Error> where Value: Decodable {
        Dlog("Decoding JSON")
        return tryMap { data, response in
            assert(!Thread.isMainThread)
            guard let code = (response as? HTTPURLResponse)?.statusCode else {
                throw APIError.unexpectedResponse
            }
            guard httpCodes.contains(code) else {
                throw APIError.httpCode(code)
            }
            return data
        }
        .extractUnderlyingError()
        .decode(type: Value.self, decoder: decoder)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

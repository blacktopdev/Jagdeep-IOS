//
//  SleepWebRepository.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/19/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation
import Combine

class SleepWebRepository: WebRepository {
    var baseUrl: String
    var session: URLSession
    let decoder: JSONDecoder = SleepWebRepository.defaultDecoder

//    static let defaultBaseUrl = "https://api.soltechealth.com"
    static let defaultBaseUrl = "https://soltechealth.com/TroyDan/.app"

    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // .formatted(DateFormatter.iso8601Full)
        return decoder
    }

    static var defaultSession: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .useProtocolCachePolicy
        config.waitsForConnectivity = true
        config.httpAdditionalHeaders = [ "Content-Type": "application/json",
                                         "Accept": "application/json; charset=utf-8" ]
        
        return URLSession(configuration: config)
    }

    private var cancelBag = CancelBag()

    init(baseUrl: String = defaultBaseUrl, session: URLSession = defaultSession) {
        self.baseUrl = baseUrl
        self.session = session
    }

    func loadMockData() -> AnyPublisher<User, Error> {
        return call(endpoint: API.monthTest)
    }
}

// MARK: - Endpoints

extension SleepWebRepository {
    enum API {
        case editedTest
        case minimalTest
        case nightTest
        case monthTest
        case yearTest
//        case countryDetails(Country)
    }
}

extension SleepWebRepository.API: APICall {
//    var rootType: Any.Type? {
//        User.self
//    }

    var path: String {
        switch self {
        case .editedTest:
            return "soltec-erd-mock-example.json"
        case .minimalTest:
            return "zmock_minimal.json"
        case .nightTest:
            return "zmock_night.json"
        case .monthTest:
            return "zmock_month.json"
        case .yearTest:
            return "zmock_year.json"
//        case .allCountries:
//            return "/all"
//        case let .countryDetails(country):
//            let encodedName = country.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            return "/name/\(encodedName ?? country.name)"
        }
    }

    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    var headers: [String: String]? {
        return nil
//        return ["Accept": "application/json"]
    }

    func body() throws -> Data? {
        return nil
    }
}

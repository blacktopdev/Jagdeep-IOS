//
//  DomainHelpers.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/15/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import CoreData

typealias SleepEnumerationType = String

protocol DomainObject: Codable, Equatable {
    static var entityName: String { get }
}

extension DomainObject {
    static var entityName: String {
        String(describing: self)
    }
}

// So it can be used to qualify SleepSignal generic.
extension Float: DomainObject { }

protocol SimpleMocking {
    static var mock: Self { get }
    static var empty: Self { get }
}

// MARK: - Converting values

//protocol StringRepresentable: CustomStringConvertible {
//    init?(_ string: String)
//}
//
//struct StringBacked<Value: StringRepresentable>: Codable {
//    var value: Value
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let string = try container.decode(String.self)
//
//        guard let value = Value(string) else {
//            throw DecodingError.dataCorruptedError(
//                in: container,
//                debugDescription: """
//                Failed to convert an instance of \(Value.self) from "\(string)"
//                """
//            )
//        }
//
//        self.value = value
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(value.description)
//    }
//}
//
//extension Date: StringRepresentable {}

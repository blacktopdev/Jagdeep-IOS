//
//  Encodable+JSON.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/27/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

extension Encodable {

    var jsonString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(self) else {
            return ""
        }

        return String(data: data, encoding: .utf8)
    }
}

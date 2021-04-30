//
//  Error+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/19/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            // "The Internet connection appears to be offline."
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}

//
//  Logging.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/27/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation
import os.log

func Dlog<T>(_ object: @autoclosure () -> T, _ category: String = "general", _ type: OSLogType = OSLogType.default, _ file: String = #file, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let stringRepresentation: String

        if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        } else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        } else {
            fatalError("Dlog only works for values that conform to CustomDebugStringConvertible or CustomStringConvertible")
        }

        let fileURL = NSURL(fileURLWithPath: file).lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        let body = "<\(queue)> \(fileURL)[\(line)]: " + stringRepresentation

        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: category)
//        os_log(body, log: log, type: actualType, body)
        os_log("%@", log: log, type: type, body)

//        print("<\(queue)> \(fileURL) \(function)[\(line)]: " + stringRepresentation)
    #endif
}

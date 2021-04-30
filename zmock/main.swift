//
//  main.swift
//  zmock
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

let args = CommandLine.arguments

if args.count < 2 {
    print("Usage:\n\tzmock <output_file> [<session_limit>] [<epoch_limit>]")
    exit(0)
}

// MARK: - Business

let context = MockingContext(args: Array(args.suffix(from: 1)))

print("Generating \(context.root.outputFile) with sessionLimit: \(context.root.sessionLimit), epochLimit: \(context.root.epochLimit)...")

let user = User.mocked(context)

// Save the result as JSON
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
encoder.dateEncodingStrategy = .iso8601// .formatted(DateFormatter.iso)

let jsonData = try encoder.encode(user)

if let jsonString = String(data: jsonData, encoding: .utf8) {
    let fm = FileManager()
    try jsonString.write(to: URL(fileURLWithPath: fm.currentDirectoryPath).appendingPathComponent(context.root.outputFile),
                         atomically: false, encoding: .utf8)
} else {
    print("Failed to create JSON string")
}

print("Completed")

//
//  SleepStageType.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

enum SleepStageType: SleepEnumerationType, CaseIterable, Codable {
    case wake
    case rem
    case light
    case delta

    var shortName: String {
        switch self {
        case .wake:
            return "W"
        case .rem:
            return "R"
        case .light:
            return "L"
        case .delta:
            return "D"
        }
    }

    var name: String {
        switch self {
        case .wake:
            return "Wake"
        case .rem:
            return "REM"
        case .light:
            return "Light"
        case .delta:
            return "Delta"
        }
    }

    var sleepLevel: Int {
        switch self {
        case .wake:
            return 0
        case .rem:
            return 1
        case .light:
            return 2
        case .delta:
            return 3
        }
    }

    static func type(forLevel level: Int) -> SleepStageType {
        switch level {
        case 1:
            return .rem
        case 2:
            return .light
        case 3:
            return .delta
        default:
            return .wake
        }
    }

    static func random<G: RandomNumberGenerator>(using generator: inout G) -> SleepStageType {
        return SleepStageType.allCases.randomElement(using: &generator)!
    }

    static func random() -> SleepStageType {
        var g = SystemRandomNumberGenerator()
        return SleepStageType.random(using: &g)
    }
}

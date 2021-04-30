//
//  SleepStream.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/14/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepStream: DomainObject {
    let arousals: [SleepArousal]
    let desaturations: [SleepDesaturation]
    let o2ses: [SleepO2SE]
    let motions: [SleepMotion]
    let sounds: [SleepSound]
    let protocols: [SleepProtocol]
}

extension SleepStream: SimpleMocking {
    static let mock = SleepStream(arousals: [], desaturations: [], o2ses: [], motions: [], sounds: [], protocols: [])

    static let empty = mock
}

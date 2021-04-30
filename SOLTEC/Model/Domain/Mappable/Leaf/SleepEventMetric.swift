//
//  SleepWakeMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepEventMetric: DomainObject {
    let arousalCount: Int
    let desatCount: Int
    let o2seCount: Int
    let motionCount: Int
    let soundCount: Int
    let protocolCount: Int
}

extension SleepEventMetric: SimpleMocking {
    static let mock = SleepEventMetric(arousalCount: Int.random(in: 5..<20),
                                       desatCount: Int.random(in: 5..<20),
                                       o2seCount: Int.random(in: 5..<20),
                                       motionCount: Int.random(in: 5..<20),
                                       soundCount: Int.random(in: 5..<20),
                                       protocolCount: Int.random(in: 5..<20))

    static let empty = SleepEventMetric(arousalCount: 0, desatCount: 0, o2seCount: 0,
                                        motionCount: 0, soundCount: 0, protocolCount: 0)
}

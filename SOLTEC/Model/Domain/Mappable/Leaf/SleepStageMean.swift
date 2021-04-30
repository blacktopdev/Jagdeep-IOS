//
//  SleepStageMean.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepStageMean: DomainObject {
    let pulseMean: Float
    let pulseDeviation: Float
    let o2Deviation: Float
    let veryLowPower: Float
    let veryLowMean: Float
    let wakeRemDiff: Float
    let veryLowRatio: Float
}

extension SleepStageMean: SimpleMocking {
    static let mock = SleepStageMean(pulseMean: Float.random(in: 0..<100),
                                     pulseDeviation: Float.random(in: 0..<100),
                                     o2Deviation: Float.random(in: 0..<100),
                                     veryLowPower: Float.random(in: 0..<100),
                                     veryLowMean: Float.random(in: 0..<100),
                                     wakeRemDiff: Float.random(in: 0..<100),
                                     veryLowRatio: Float.random(in: 0..<100))

    static let empty = SleepStageMean(pulseMean: 0, pulseDeviation: 0, o2Deviation: 0,
                                      veryLowPower: 0, veryLowMean: 0, wakeRemDiff: 0, veryLowRatio: 0)
}

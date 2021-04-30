//
//  SleepSessionMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepSessionMetric: DomainObject {
    let recordDuration: Float
    let sleepDuration: Float
    let sleepOnset: Float

    let cumulativeTime: SleepStageMetric
    let stagePulse: SleepStageMetric
    let stageO2: SleepStageMetric

    let remEvent: SleepEventMetric
    let lightEvent: SleepEventMetric
    let deltaEvent: SleepEventMetric
}

extension SleepSessionMetric: SimpleMocking {
    static let mock = SleepSessionMetric(recordDuration: Float.random(in: 3*3600..<11*3600),
                                         sleepDuration: Float.random(in: 3*3600..<11*3600),
                                         sleepOnset: Float.random(in: 3*3600..<11*3600),
                                         cumulativeTime: SleepStageMetric.mock,
                                         stagePulse: SleepStageMetric.mock,
                                         stageO2: SleepStageMetric.mock,
                                         remEvent: SleepEventMetric.mock,
                                         lightEvent: SleepEventMetric.mock,
                                         deltaEvent: SleepEventMetric.mock)

    static let empty = SleepSessionMetric(recordDuration: 0,
                                          sleepDuration: 0,
                                          sleepOnset: 0,
                                          cumulativeTime: SleepStageMetric.empty,
                                          stagePulse: SleepStageMetric.empty,
                                          stageO2: SleepStageMetric.empty,
                                          remEvent: SleepEventMetric.empty,
                                          lightEvent: SleepEventMetric.empty,
                                          deltaEvent: SleepEventMetric.empty)
}

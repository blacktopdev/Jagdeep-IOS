//
//  SleepTrend.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepTrend: DomainObject {
    let stageAggregate: SleepStageAggregate
    let cumulativeTimes: [SleepStageMetric]
    let sessionAggregate: SleepSessionAggregate
    let deltaHFPF: Float
    let epochCounts: [Int]
}

extension SleepTrend: SimpleMocking {
    static var mock = SleepTrend(stageAggregate: SleepStageAggregate.mock,
                                 cumulativeTimes: (0..<50).map { _ in SleepStageMetric.mock },
                                 sessionAggregate: SleepSessionAggregate.mock,
                                 deltaHFPF: Float.random(in: 0..<100),
                                 epochCounts: (0..<50).map { _ in Int.random(in: 4000..<8000) })

    static var empty = SleepTrend(stageAggregate: SleepStageAggregate.empty,
                                  cumulativeTimes: [],
                                  sessionAggregate: SleepSessionAggregate.empty,
                                  deltaHFPF: 0, epochCounts: [])
}
